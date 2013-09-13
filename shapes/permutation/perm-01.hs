
-- initial permutation


blah _ [] = []
blah as (b1:bs) = (show b1,show (as ++ bs)) : blah (as++[b1]) bs


perm [] = [] -- ?
perm [a] = [a]
perm as = undefined
