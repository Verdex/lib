
module( ..., package.seeall )


local function anaHelper( accum, gen, pred, s )
    if pred( s ) then
        return accum
    end

    local a, s = gen( s )
    accum[#accum + 1] = a
    return anaHelper( accum, gen, pred, s )
end

-- generator : b -> (a, b)
-- stopPred : b -> bool
-- anamorphism : b -> [a]
function ana( generator, stopPred )
    return function( seed ) return anaHelper( {}, generator, stopPred, seed )
end

-- initial : b
-- folder : (a, b) -> b
-- catamorphism : [a] -> b
function cata( initial, folder )
    return function( array )
        for _, a in ipairs( array ) do
            initial = folder( a, initial )
        end
        return initial
    end
end

-- TODO make sure to test this, im not convinced i got this right
local function hyloHelper( i, fold, gen, pred, s )
    if pred( s ) then
        return i 
    end
   
    local a, s = gen( s )
    return fold( a, hyloHelper( i, folder, gen, pred, s ) )
end 
    
function hylo( initial, folder, generator, stopPred )
    return function( seed ) return hyloHelper( initial, folder, generator, stopPred, seed )
end
