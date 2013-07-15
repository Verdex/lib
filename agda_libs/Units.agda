-- TODO:  Need a way to reduce and equate SUnit (mi * mi / mi == mi / 1 and 
--                                                mi sec == sec mi, etc)
-- really want I want is permutation equivalence
-- It looks like there are two ways to prove a property
-- 1) create an explicit proof object
-- 2) create data type that "implements" the permutation property

module Units where

    open import List
    open import Number

    data Unit : Set where
        mile : Unit 
        second : Unit

    data SUnit : List Unit -> List Unit -> Set where
        sunit : { a b : List Unit } -> Nat -> SUnit a b

    miles : Nat -> SUnit (mile :: []) []
    miles = sunit

    seconds : Nat -> SUnit (second :: []) []
    seconds = sunit
   
    mult : { a b c d : List Unit } -> SUnit a b -> SUnit c d  -> SUnit (a ++ c) (b ++ d)
    mult (sunit n1) (sunit n2) = sunit (n1 * n2)

    add : { a b : List Unit } -> SUnit a b -> SUnit a b -> SUnit a b
    add (sunit n1) (sunit n2) = sunit (n1 + n2)
