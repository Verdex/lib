
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


wocky _ s c [] = c (s [])
wocky _ s c [a] = c (s [a])
wocky trans split combine as = combine (map (trans (wocky trans split combine)) (split as))

mergeSort :: Ord a => [a] -> [a]
mergeSort = wocky id halfList mergeLists


--split : [a] -> [[a]]
--comb : [[a]] -> [b]

-- map : ((c, [a]) -> (c, [a])) -> [(c, [a])]
-- trans : ([a] -> [a]) -> (c, [a]) -> (c, [a]) 
-- split : [a] -> [(c, [a])]
-- comb : [(c, [a])] -> [a]
-- wocky : [a] -> [b]

