
module Logical where

    data False : Set where

    data True : Set where
        tt : True

    data Bool : Set where
        true : Bool
        false : Bool

    isTrue : Bool -> Set
    isTrue true = True
    isTrue false = False

    _and_ : Bool -> Bool -> Bool
    false and _ = false
    _ and false = false
    true and true = true

    infixl 50 _and_
