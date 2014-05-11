
module Sudoku where

require True = [0]
require False = []


x = do 
    y <- [1,2,3]
    z <- [3,4,5]
    require $ y == z
    return (y, z)


