
module Units where

    data Nat : Set where
        zero : Nat
        suc : Nat -> Nat

    data Unit : Set where
        mile : Unit 
        second : Unit
        unit : Unit

    data List ( A : Set ) : Set where
        [] : List A
        _::_ :  A -> List A -> List A 
        
    _++_ : { A : Set } -> List A -> List A -> List A
    [] ++ b = b
    (h :: t) ++ b = t ++ (h :: b)

    data SUnit : List Unit -> List Unit -> Set where
        sunit : ( a : List Unit ) -> ( b : List Unit ) -> SUnit a b
