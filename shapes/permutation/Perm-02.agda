
module Perm-02 where

    data Stuff : Set where
        a : Stuff
        b : Stuff
        c : Stuff
    
    data List ( A : Set ) : Set where
        [] : List A
        _::_ : A -> List A -> List A

    infixr 5 _::_
        
    _++_ : { A : Set } -> List A -> List A -> List A
    [] ++ b = b
    (h :: t) ++ b = h :: (t ++ b)

    infixr 5 _++_

    map : { A B : Set } -> (A -> B) -> List A -> List B
    map f [] = []
    map f (a :: as) = f a :: (map f as)
