-- TODO : mult needs a reduction function that will convert mi * mi / mi to mi
-- Note:  having to do add a b tt tt is kind of tedious and silly, however
-- I honestly don't see why you can't modify the type checker so that predicates 
-- can be added to the type signature and then the tt will automatically be thrown in
-- function application.  I think may miss some mathematical point, but it might end
-- up being super useful for more practical minded dependent typers.

module Units where

    open import Logical
    open import List
    open import Number

    data Unit : Set where
        mile : Unit 
        second : Unit

    eqUnit : Unit -> Unit -> Bool
    eqUnit mile mile = true
    eqUnit second second = true
    eqUnit _ _ = false

    data SUnit : List Unit -> List Unit -> Set where
        sunit : { a b : List Unit } -> Nat -> SUnit a b

    miles : Nat -> SUnit (mile :: []) []
    miles = sunit

    seconds : Nat -> SUnit (second :: []) []
    seconds = sunit
   
    mult : { a b c d : List Unit } -> 
            SUnit a b -> SUnit c d ->
            SUnit (a ++ c) (b ++ d)
    mult (sunit n1) (sunit n2) = sunit (n1 * n2)

    add : { a b c d : List Unit } -> 
            SUnit a b -> 
            SUnit c d -> 
            isTrue (arePermutations eqUnit a c) -> 
            isTrue (arePermutations eqUnit b d) -> 
            SUnit a b
    add (sunit n1) (sunit n2) p1 p2 = sunit (n1 + n2)
