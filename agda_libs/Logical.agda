
module Logical where

    data Bool : Set where
        true : Bool
        false : Bool

    _and_ : Bool -> Bool -> Bool
    false and _ = false
    _ and false = false
    true and true = true

    infixl 50 _and_
