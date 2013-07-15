
module Number where

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


