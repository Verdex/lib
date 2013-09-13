
blah _ [] = []
blah as (b1:bs) = (show b1,show (as ++ bs)) : blah (as++[b1]) bs

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

wocky _ _ [] = []
wocky _ _ [a] = [a]
wocky split combine as = combine (map (wocky split combine) (split as))

mergeSort :: Ord a => [a] -> [a]
mergeSort = wocky halfList mergeLists


--split : [a] -> [[a]]
--comb : [[a]] -> [b]

--final :: [a] -> [b]
