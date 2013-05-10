
module( ..., package.seeall )


local function anaHelper( accum, gen, pred, b )
    if pred( b ) then
        return accum
    end

    local a, b = gen( b )
    accum[#accum + 1] = a
    return anaHelper( accum, gen, pred, b )
end

-- generator : b -> (a, b)
-- stopPred : b -> bool
-- anamorphism : b -> [a]
function ana( generator, stopPred )
    return function( b ) return anaHelper( {}, generator, stopPred, b )
end
