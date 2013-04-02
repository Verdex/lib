
require 'readonly'
require 'test'

test.init()

function test_shouldErrorWhenSettingIndex()
    local ro = readonly.shallowReadonly{ 1, 2, 3 }
    test.assertThrows( function () ro[1] = 10 end )
end

function test_shouldErrorWhenSettingIndexOutOfRange()
    local ro = readonly.shallowReadonly{ 1, 2, 3 }
    test.assertThrows( function () ro[0] = 10 end )
    test.assertThrows( function () ro[4] = 10 end )
end

function test_shouldErrorWhenSettingField()
    local ro = readonly.shallowReadonly{ 1, 2, 3, a = "cat" } 
    test.assertThrows( function () ro.a = "dog" end )
end
    
function test_shouldErrorWhenSettingNilField()
    local ro = readonly.shallowReadonly{ 1, 2, 3, a = "cat" } 
    test.assertThrows( function () ro.b = "dog" end )
end

function test_shouldAccessIndices()
    local ro = readonly.shallowReadonly{ 1, 2, 3 }
    assert( ro[0] == nil )
    assert( ro[1] == 1 )
    assert( ro[2] == 2 )
    assert( ro[3] == 3 )
    assert( ro[4] == nil )
end

function test_shouldAccessFields()
    local ro = readonly.shallowReadonly{ a = "cat", b = "dog"  }
    assert( ro.a == "cat" )
    assert( ro.b == "dog" )
    assert( ro.c == nil )
end

function test_shouldHandleStrangeKey()
    local key = {}
    local ro = readonly.shallowReadonly{ [key] = "dog" }
    assert( ro[key] == "dog" )
end

function test_ipairsReplacementShouldWork()
    local ro = readonly.shallowReadonly{ 1, 2, 3, a = "cat" }
    local accum = {}
    local i = 1
    for k, v in ro:ipairs() do
        assert( k == i )
        i = i + 1
        accum[#accum + 1] = v
    end
    assert( accum[1] == 1 )
    assert( accum[2] == 2 )
    assert( accum[3] == 3 )
end

function test_pairsReplacementShouldWork()
    local key = {}
    local ro = readonly.shallowReadonly{ 1, 2, 3, a = "cat", b = "dog", [key] = "bear" }

    local accum = {}
    for k, v in ro:pairs() do
        accum[k] = v
    end

    assert( accum[1] == 1 )
    assert( accum[2] == 2 )
    assert( accum[3] == 3 )
    assert( accum.a == "cat" )
    assert( accum.b == "dog" )
    assert( accum[key] == "bear" )
end

function test_lengthMethodShouldFunction()
    local ro = readonly.shallowReadonly{ 1, 2, 3, 4, a = "a" }

    assert( ro:length() == 4 )
end
    
function test_isReadonlyShouldFunction()
    local ro = readonly.shallowReadonly{ 1,2,3 }
    local o = { 1,2,3 }

    assert( readonly.isReadonly( ro ) == true )
    assert( readonly.isReadonly( o ) == false )
end
