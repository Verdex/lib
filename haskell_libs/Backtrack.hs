
module Backtrack where

{-

    do
        a <- var [1,2,3]
        b <- var ['a', 'b', 'c']
        return ( a, b )

(1,'a')


    do
        a <- var [1,2,3,4]
        require ( a == 3 )
        b <- var [2, 4, 6]
        require ( a % b == 0 ) 
        return ( a, b )


eval : m ? -> ?

-}


