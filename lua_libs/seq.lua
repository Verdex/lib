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
