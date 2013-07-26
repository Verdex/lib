
module List where

    open import Logical

    data List ( A : Set ) : Set where
        [] : List A
        _::_ :  A -> List A -> List A 

    infixr 5 _::_

    _++_ : { A : Set } -> List A -> List A -> List A
    [] ++ b = b
    (h :: t) ++ b = t ++ ( h :: b )

    -- I'll look into figuring out a better way to handle equality
    -- later (it's not really what I'm interested right now)
    isMember : { A : Set } -> (A -> A -> Bool) -> A -> List A -> Bool
    isMember eq item [] = false
    isMember eq item (a :: as) with eq item a
    ... | true = true
    ... | false = isMember eq item as

    arePermutations : { A : Set } -> (A -> A -> Bool) -> List A -> List A -> Bool
    arePermutations eq [] [] = true
    arePermutations eq [] (b :: bs) = false
    arePermutations eq (a :: as) [] = false
    -- not right yet, pretty sure i need a remove function
    arePermutations eq (a :: as) (b :: bs) = 
        (isMember eq a bs) 
        and (isMember eq b as) 
        and (arePermutations eq as (b :: bs))
        and (arePermutations eq bs (a :: as))

