
blah _ [] = []
blah as (b1:bs) = (show b1, show (as ++ bs)) : blah (as++[b1]) bs

ikky :: (a->b) -> (b->[a]->c) -> [a] -> [a] -> [c]
ikky f g _ [] = []
ikky f g as (b:bs) = (g (f b) (as ++ bs)) : ikky f g (as++[b]) bs

half ([],bs) = [[],bs]
half ((a:as),bs)
    | length (a:as) <= length bs = [(a:as),bs]
    | otherwise = half (as, a:bs)

halfList as = half (as,[])

mergeLists :: Ord a => [[a]] -> [a]
mergeLists = foldr mergeList []

mergeList a [] = a
mergeList [] b = b
mergeList (a:as) (b:bs)
    | a < b = a : mergeList as (b:bs)
    | otherwise = b : mergeList (a:as) bs

wocky :: (([a] -> b) -> c -> c) -> ([a] -> [c]) -> ([c] -> b) -> [a] -> b
wocky _ s c [] = c (s [])
wocky _ s c [a] = c (s [a])
wocky trans split combine as = combine (map (trans (wocky trans split combine)) (split as))

mergeSort :: Ord a => [a] -> [a]
mergeSort = wocky id halfList mergeLists

permSplit :: [a] -> [(a, [a])]
permSplit = permSplitHelper []

permSplitHelper _ [] = []
permSplitHelper as (b:bs) = (b, (as ++ bs)) : permSplitHelper (as++[b]) bs

permComb :: [(a, [a])] -> [[a]]
permComb [] = []
permComb ((f, rs) : ns) = (f:rs) : permComb ns

permTrans :: ([a] -> [[a]]) -> (c, [a]) -> (c, [a])
permTrans f (c, as) = (c, foldr (++) [] (f as))

perm :: [a] -> [[a]]
perm = wocky permTrans permSplit permComb

--split : [a] -> [[a]]
--comb : [[a]] -> [b]

-- map : ((c, [a]) -> (c, [a])) -> [(c, [a])]
-- trans : ([a] -> [a]) -> (c, [a]) -> (c, [a]) 
-- split : [a] -> [(c, [a])]
-- comb : [(c, [a])] -> [[a]]
-- wocky : [a] -> [b]

