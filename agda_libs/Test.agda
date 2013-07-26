
module Test where

    open import Logical
    open import List
    open import Number
    open import Units
    
    data Stuff : Set where
        ah : Stuff
        bah : Stuff
        cah : Stuff

    eqS : Stuff -> Stuff -> Bool
    eqS ah ah = true
    eqS bah bah = true
    eqS cah cah = true
    eqS _ _ = false

    a = ah :: bah :: bah :: ah :: []
    b = bah :: bah :: ah :: ah :: []
    c = cah :: bah :: bah :: ah :: ah :: []

    

    ikky : SUnit ( mile :: second :: [] ) []
    ikky = sunit (suc zero)

    blargR = mult (miles zero) (seconds zero) 
    blargL = mult (seconds zero) (miles zero) 

    jabber : SUnit ( second :: mile :: [] ) []
    jabber = sunit (suc zero) 

    mal = mult (miles zero) (miles zero)

    outcome1 = add blargR blargL tt tt
    outcome2 = add blargR jabber tt tt 

    --outcome3 = add blargR mal tt tt
    
