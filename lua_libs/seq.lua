--[[

Altering an array, mutable element, or mutable internal value of an element
after it has been given to a sequence or doing the same to the output of
a sequence evaluation is undefined.  The effect on sibling, ancestor, or
descendent sequences is almost definitely not desired.

--]]


module( ..., package.seeall )

require 'readonly'


local seqMeta = {}

function seqMeta.evaluate( seq )
    if rawget( seq, "output" ) then
        return seq.output
    end
    local output = seq.op(
        seq.parent.evaluate,
        unpack( seq.args ) )
    seq.parent = nil -- remove so GC can happen on parent
    seq.output = readonly.shallowReadonly( output )
    return seq.output 
end

local function newNode( parent, op, args )
    local o = { 
        parent = parent, 
        op = op, 
        args = args }
    setmetatable( o, seqMeta )
    return o
end

function seqMeta.__index( seq, key )
    local res = seqMeta[key]
    if res == nil then
        error( "unknown command sent to seq:  " .. key )
    elseif key == 'evaluate' then
        return res( seq ) 
    end
    return function ( ... ) 
        return newNode( seq, res, {...} )
    end
end

function empty()
    local seq = { output = readonly.shallowReadonly{} }
    setmetatable( seq, seqMeta )
    return seq
end

function toSeq( array )
    local seq = { output = readonly.shallowReadonly( array ) }
    setmetatable( seq, seqMeta )
    return seq 
end

function seqMeta.map( input, func )
    local output = {}
    for _, v in input:ipairs() do
        output[#output + 1] = func( v )
    end
    return output
end
    
function seqMeta.where( input, pred )
    local output = {}
    for _, v in input:ipairs() do
        if pred( v ) then
            output[#output + 1] = v
        end
    end
    return output
end

function seqMeta.reverse( input )
    local output = {}
    local revIndex = input:length() + 1
    for i, v in input:ipairs() do
        output[revIndex - i] = v
    end
    return output
end

function seqMeta.concat( input, otherList )
    local output = {}
    for _, v in input:ipairs() do
        output[#output + 1] = v
    end
    if getmetatable( otherList ) == seqMeta then
        for _, v in otherList.evaluate:ipairs() do
            output[#output + 1] = v
        end
    elseif readonly.isReadonly( otherList ) then
        for _, v in otherList:ipairs() do
            output[#output + 1] = v
        end
    elseif type( otherList ) == 'table' then
        for _, v in ipairs( otherList ) do
            output[#output + 1] = v
        end
    else
        output[#output + 1] = otherList -- not a list, but probably a scalar
    end
    return output
end

function seqMeta.drop( input, dropCount )
    local output = {}
    for i = dropCount + 1, input:length() do
        output[#output + 1] = input[i]
    end
    return output
end

function seqMeta.take( input, takeCount )
    local output = {}
    for i = 1, takeCount do
        output[#output + 1] = input[i]
    end
    return output
end

function seqMeta.dropWhile( input, pred )
    local output = {}
    local done = false
    for _, v in input:ipairs() do
        if done == false and pred( v ) == false then
            done = true
        end
        if done then
            output[#output + 1] = v
        end
    end
    return output
end

function seqMeta.takeWhile( input, pred )
    local output = {}
    for i, v in input:ipairs() do
        if pred( v ) == false then
            break
        end
        output[i] = v
    end
    return output
end

local function zipWithHelper( ro1, ro2, zip )
    local l1 = ro1:length()
    local l2 = ro2:length()
    local i = 1
    local output = {}

    while i <= l1 and i <= l2 do
        output[i] = zip( ro1[i], ro2[i] )
        i = i + 1
    end
    return output 
end

function seqMeta.zipWith( input1, input2, zip )
    if getmetatable( input2) == seqMeta then
        return zipWithHelper( input1, input2.evaluate, zip )
    elseif readonly.isReadonly( input2 ) then
        return zipWithHelper( input1, input2, zip )
    elseif type( input2 ) == 'table' then
        return zipWithHelper( input1, readonly.shallowReadonly( input2 ), zip )
    else
        error "unknown array type"
    end
end


-- TODO several cases of output[#output+1] can be replaced with output[i] (not all)
-- TODO  zipWith
-- TODO fold, all, and any other function that reduces to a scalar
-- isn't going to work very well.  Need to find work around.
