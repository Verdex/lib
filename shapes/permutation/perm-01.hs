
blah _ [] = []
blah as (b1:bs) = (show b1,show (as ++ bs)) : blah (as++[b1]) bs

ikky :: (a->b) -> (b->[a]->c) -> [a] -> [a] -> [c]
ikky f g _ [] = []
ikky f g as (b:bs) = (g (f b) (as ++ bs)) : ikky f g (as++[b]) bs

perm [] = [] -- ?
perm [a] = [a]
perm as = undefined
