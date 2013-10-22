
module( ..., package.seeall )

require 'morphism'

function fold( as, b, func )
    return morphism.cata( b, func )( as )
end

