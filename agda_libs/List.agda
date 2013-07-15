
module List where

    data List ( A : Set ) : Set where
        [] : List A
        _::_ :  A -> List A -> List A 

    infixr 5 _::_

    _++_ : { A : Set } -> List A -> List A -> List A
    [] ++ b = b
    (h :: t) ++ b = t ++ ( h :: b )

