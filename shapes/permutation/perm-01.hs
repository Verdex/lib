
blah _ [] = []
blah as (b1:bs) = (show b1,show (as ++ bs)) : blah (as++[b1]) bs

ikky :: (a->b) -> (b->[a]->c) -> [a] -> [a] -> [c]
ikky f g _ [] = []
ikky f g as (b:bs) = (g (f b) (as ++ bs)) : ikky f g (as++[b]) bs

--jabber :: [a] -> [[a]]
--jabber a = ikky 


--perm [] = [[]] -- ?
--perm as = ikky (\j-> (j:)) (\p-> \d -> map p (perm d)) [] as

half ((a:as),bs)
    | length (a:as) <= length bs = [a:as, bs]
    | otherwise = half (as, a:bs)

halfList as = half (as,[])

mergeLists [[]] = []
mergeLists 

mergeList a [] = a
mergeList [] b = b
mergeList (a:as) (b:bs)
    | a < b = a : mergeList as (b:bs)
    | otherwise = b : mergeList (a:as) bs

wocky _ _ [] = []
wocky split combine as = combine (map (wocky split combine) (split as))

mergeSort = wocky halfList mergeList
