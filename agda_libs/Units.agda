-- TODO:  Need a way to reduce and equate SUnit (mi * mi / mi == mi / 1 and 
--                                                mi sec == sec mi, etc)
-- really want I want is permutation equivalence

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

    infixl 20 _*_

    data Unit : Set where
        mile : Unit 
        second : Unit

    data List ( A : Set ) : Set where
        [] : List A
        _::_ :  A -> List A -> List A 

    infixr 10 _::_
        
    _++_ : { A : Set } -> List A -> List A -> List A
    [] ++ b = b
    (h :: t) ++ b = t ++ (h :: b)

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
