
module Test where

    open import List
    open import Number
    open import Units
    

    ikky : SUnit ( mile :: second :: [] ) []
    ikky = sunit (suc zero)

    blarg = mult (miles zero) (seconds zero)

    jabber : SUnit ( second :: mile :: [] ) []
    jabber = sunit (suc zero)
