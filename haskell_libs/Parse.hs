
module Parse where

data Parser a = Parse( String -> ( Maybe a, Parser a, String ) )
    | Stop


-- TODO if the first parser fails then it probably makes sense to use its retry
instance Monad Parser where
    Stop >>= _ = Parse $ \ str -> ( Nothing, Stop, str )
    (Parse p1) >>= p2_gen = Parse $ \ str -> case p1 str of 
        (Nothing, _, _) -> ( Nothing, Stop, str )
        (Just val_p1, retry, str2) -> case p2_gen val_p1 of
            Stop -> ( Nothing, Stop, str )
            (Parse p2) -> case p2 str2 of
                (Nothing, _, _) -> case retry >>= p2_gen of
                    Stop -> (Nothing, Stop, str)
                    (Parse r) -> r str
                (val_p2, retry2, str3) -> (val_p2, retry2, str3)                   
    return a = Parse $ \ str -> ( Just a, Stop, str )

get_string target = 
    let l = length target in
        Parse $ \ str -> case take l str == target of
            True -> ( Just target, Stop, drop l str )
            False -> ( Nothing, Stop, str )

-- TODO this function should be renamed one or two
-- Still needs some work
exactly :: Int -> Parser a -> Parser [a]
exactly _ Stop = Stop
exactly 0 (Parse p) = Parse $ \ str ->   
    let (_,retry,str2) = p str in
        (Just [], exactly 0 retry, str) 
exactly n p = 
    do
        h <- p
        r <- exactly (n-1) p
        return (h:r)

non_greedy_oneOrMore :: Parser a -> Parser [a]
non_greedy_oneOrMore Stop = Stop
non_greedy_oneOrMore (Parse p) = Parse $ \ str -> case p str of
    (Nothing, _, _) -> (Nothing, Stop, str)
    (Just v, _, str2) -> let re = do 
                                a <- Parse p
                                b <- non_greedy_oneOrMore (Parse p)
                                return ( a : b )
                    in (Just [v], re, str2 )

test = do
        a <- get_string "blah"
        b <- get_string "3"
        return (a,b)

test2 = do
    a <- non_greedy_oneOrMore (get_string "a")
    b <- non_greedy_oneOrMore (get_string "a")
    c <- get_string "b"
    return (a,b,c)


run Stop _ = Nothing
run (Parse p) s = case p s of
    (Nothing, _, _) -> Nothing
    (v, _, _) -> v
