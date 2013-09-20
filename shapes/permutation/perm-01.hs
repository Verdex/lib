
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

--wocky :: (([a] -> b) -> c -> c) -> ([a] -> [c]) -> ([c] -> b) -> [a] -> b
--wocky b t s c [] = c (map (t (\ as -> b)) (s []))
--wocky b t s c [a] = c (map (t (wocky t s c)) (s [a]))
--wocky b trans split combine as = combine (map (trans (wocky trans split combine)) (split as))

--mergeSort :: Ord a => [a] -> [a]
--mergeSort = wocky [] id halfList mergeLists

permSplit :: [a] -> [(a, [a])]
permSplit = permSplitHelper []

permSplitHelper _ [] = []
permSplitHelper as (b:bs) = (b, (as ++ bs)) : permSplitHelper (as++[b]) bs

permComb = foldl (++) []

permTrans :: ([a] -> [[a]]) -> (a, [a]) -> [[a]] 
permTrans f (c, as) = map (c:) (f as)

--perm :: [a] -> [[a]]
--perm = wocky [[]] permTrans permSplit permComb

perm2 :: [a] -> [[a]]
perm2 [] = [[]]
perm2 as = foldl (++) [] (map ( \ (b, bs) -> map (b:) (perm2 bs) ) (permSplit as))

perm3 :: ((f a -> j a) -> m (f a) -> j a) 
            -> ([j a] -> j a) 
            -> (f a -> [m (f a)])
            -> f a -> j a

perm3 t c s as = c (map (t (perm3 t c s)) (s as))

--perm4 :: [a] -> [[a]]
--perm4 = perm3 permTrans permComb permSplit


perm5 :: (m (f a) -> j a) 
            -> ([j a] -> j a) 
            -> (f a -> [m (f a)])
            -> f a -> j a

perm5 r c s as = c (map r (s as))

perm6 :: [a] -> [[a]]
perm6 = perm5 (permTrans perm6) permComb permSplit
