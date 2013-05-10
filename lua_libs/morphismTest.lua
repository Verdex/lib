require 'morphism'
require 'test'

_ENV = test.init()


function test_anamorphismShouldWork()
    local iterate = morphism.ana( 
        function ( i ) return i, i + 1 end,
        function ( i ) return i == 4 end )

    local o = iterate( 1 )

    assert( o[1] == 1 )
    assert( o[2] == 2 )
    assert( o[3] == 3 )
    assert( o[4] == nil )
end

function test_catamorphismShouldWork()
    local sum = morphism.cata( 
        0,
        function ( a, b ) b = a + b; return b end )

    local o = sum{ 1, 2, 3, 4, 5 } 

    assert( o == 15 )
end

function test_hylomorphismShouldWork()
    local sumFromToTen = morphism.hylo(
        0, 
        function( a, b ) b = a + b; return b end,
        function( b ) return b, b + 1 end,
        function( b ) return b == 10 end )

    local o = sumFromToTen( 2 )

    assert( o == 44 )
end
