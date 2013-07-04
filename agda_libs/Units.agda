
module Units where

    data Nat : Set where
        zero : Nat
        suc : Nat -> Nat

    _+_ : Nat -> Nat -> Nat
    zero + b = b
    suc a + b = suc ( a + b )

    infixl 10 _+_

    _*_ : Nat -> Nat -> Nat
    _ * zero = zero
    a * (suc zero) = a
    a * (suc b) = a * b + a

    infixl 10 _*_

    data Unit : Set where
        mile : Unit 
        second : Unit
        unit : Unit

    data List ( A : Set ) : Set where
        [] : List A
        _::_ :  A -> List A -> List A 

    infixr 10 _::_
        
    _++_ : { A : Set } -> List A -> List A -> List A
    [] ++ b = b
    (h :: t) ++ b = t ++ (h :: b)

    data SUnit : List Unit -> List Unit -> Set where
        sunit : ( a : List Unit ) -> ( b : List Unit ) -> SUnit a b

    --smult (n1, t1) (n2, t2) = (n1 * n2    
