
module List where

    open import Logical

    data List ( A : Set ) : Set where
        [] : List A
        _::_ :  A -> List A -> List A 

    infixr 5 _::_

    _++_ : { A : Set } -> List A -> List A -> List A
    [] ++ b = b
    (h :: t) ++ b = t ++ ( h :: b )

    any : { A : Set } -> (A -> Bool) -> List A -> Bool
    any pred [] = false
    any pred (a :: as) with pred a 
    ... | true = true
    ... | false = any pred as

    removeFirstMatch : { A : Set } -> (A -> Bool) -> List A -> List A
    removeFirstMatch match [] = []
    removeFirstMatch match (a :: as) with match a
    ... | true = as
    ... | false = a :: (removeFirstMatch match as)

    arePermutations : { A : Set } -> (A -> A -> Bool) -> List A -> List A -> Bool
    arePermutations eq [] [] = true
    arePermutations eq [] (b :: bs) = false
    arePermutations eq (a :: as) [] = false
    arePermutations eq (a :: as) bs = 
        (any (eq a) bs)
        and (arePermutations eq as (removeFirstMatch (eq a) bs))

