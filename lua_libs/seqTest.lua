
require 'seq'
require 'readonly'
require 'test'

test.init()

function test_shouldEvaluateOpLessSeq()
    local s = seq.toSeq{ 1,2,3 }
    local sEval = s.evaluate

    assert( sEval[0] == nil )
    assert( sEval[1] == 1 )
    assert( sEval[2] == 2 )
    assert( sEval[3] == 3 )
    assert( sEval[4] == nil )
end

function test_shouldEvaluateSingleOpSeqPostParentEval()
    local s = seq.toSeq{ 1,2,3 }
    local sEval = s.evaluate
    local single = s.map( function ( v ) return v + 1 end )
    local singleEval = single.evaluate

    assert( singleEval[0] == nil )
    assert( singleEval[1] == 2 )
    assert( singleEval[2] == 3 )
    assert( singleEval[3] == 4 )
    assert( singleEval[4] == nil )

    assert( sEval[0] == nil )
    assert( sEval[1] == 1 )
    assert( sEval[2] == 2 )
    assert( sEval[3] == 3 )
    assert( sEval[4] == nil )
end

function test_shouldEvaluateSingleOpSeqPreParentEval()
    local s = seq.toSeq{ 1,2,3 }
    local single = s.map( function ( v ) return v + 1 end )
    local singleEval = single.evaluate

    assert( singleEval[0] == nil )
    assert( singleEval[1] == 2 )
    assert( singleEval[2] == 3 )
    assert( singleEval[3] == 4 )
    assert( singleEval[4] == nil )

    local sEval = s.evaluate

    assert( sEval[0] == nil )
    assert( sEval[1] == 1 )
    assert( sEval[2] == 2 )
    assert( sEval[3] == 3 )
    assert( sEval[4] == nil )
end

function test_shouldHandleMultipleOps()
    local mult = seq.toSeq{ 1,2,3 }
        .map( function ( x ) return x + 1 end )
        .map( function ( x ) return x + 2 end ).evaluate

    assert( mult[0] == nil )
    assert( mult[1] == 4 )
    assert( mult[2] == 5 )
    assert( mult[3] == 6 )
    assert( mult[4] == nil )
end

function test_shouldHandleTreeStructure()
    local root = seq.toSeq{ 1,2,3 }
    local left = root.map( function ( v ) return v + 10 end )
    local right = root.map( function ( v ) return v + 20 end )
    local lr = left.map( function ( v ) return v + 30 end )
    local ll = left.map( function ( v ) return v + 40 end )

    local o = ll.evaluate

    assert( o[0] == nil )
    assert( o[1] == 51 )
    assert( o[2] == 52 )
    assert( o[3] == 53 )
    assert( o[4] == nil )

    o = lr.evaluate

    assert( o[0] == nil )
    assert( o[1] == 41 )
    assert( o[2] == 42 )
    assert( o[3] == 43 )
    assert( o[4] == nil )

    o = left.evaluate

    assert( o[0] == nil )
    assert( o[1] == 11 )
    assert( o[2] == 12 )
    assert( o[3] == 13 )
    assert( o[4] == nil )

    o = right.evaluate

    assert( o[0] == nil )
    assert( o[1] == 21 )
    assert( o[2] == 22 )
    assert( o[3] == 23 )
    assert( o[4] == nil )

    o = root.evaluate

    assert( o[0] == nil )
    assert( o[1] == 1 )
    assert( o[2] == 2 )
    assert( o[3] == 3 )
    assert( o[4] == nil )
end

function test_mapShouldHandleEmptySeq()
    local e = seq.empty().map( function ( v ) return v + 1 end ).evaluate

    assert( e[1] == nil )
end

function test_whereShouldFunctionCorrectly()
    local observed = seq.toSeq{ 1,2,3,4,5,6 }
        .where( function ( v ) return v % 2 == 0 end ).evaluate

    assert( observed[1] == 2 )
    assert( observed[2] == 4 )
    assert( observed[3] == 6 )
end

function test_whereShouldHandleEmptySeq()
    local e = seq.empty().where( function ( v ) return v % 2 == 0 end ).evaluate

    assert( e[1] == nil )
end

function test_shouldHandleMultipleOpTypes()
    local o = seq.toSeq{ 1,2,3 }
        .map( function ( v ) return v + 1 end )
        .where( function ( v ) return v % 2 == 0 end ).evaluate

    assert( o[1] == 2 )
    assert( o[2] == 4 )
end

function test_reverseShouldWork()
    local o1 = seq.toSeq{ 1,2,3,4 }.reverse().evaluate

    assert( o1[0] == nil )
    assert( o1[1] == 4 )
    assert( o1[2] == 3 )
    assert( o1[3] == 2 )
    assert( o1[4] == 1 )
    assert( o1[5] == nil )

    local o2 = seq.toSeq{ 1,2,3 }.reverse().evaluate

    assert( o2[0] == nil )
    assert( o2[1] == 3 )
    assert( o2[2] == 2 )
    assert( o2[3] == 1 )
    assert( o2[4] == nil )
end

function test_concatShouldWorkWithLists()
    local o = seq.toSeq{ 1,2,3 }.concat{ 4,5,6 }.evaluate

    assert( o[1] == 1 )
    assert( o[2] == 2 )
    assert( o[3] == 3 )
    assert( o[4] == 4 )
    assert( o[5] == 5 )
    assert( o[6] == 6 )
end

function test_concatShouldWorkWithEmptyLists()
    local o = seq.toSeq{ 1,2,3 }.concat{}.evaluate

    assert( o[1] == 1 )
    assert( o[2] == 2 )
    assert( o[3] == 3 )
    assert( o[4] == nil )
end

function test_concatShouldWorkWithReadOnlyLists()
    local o = seq.toSeq{ 1,2,3 }.concat( readonly.shallowReadonly{ 4,5,6 } ).evaluate

    assert( o[1] == 1 )
    assert( o[2] == 2 )
    assert( o[3] == 3 )
    assert( o[4] == 4 )
    assert( o[5] == 5 )
    assert( o[6] == 6 )
end

function test_concatShouldWorkWithSeq()
    local o = seq.toSeq{ 1,2,3 }
        .concat( 
            seq.toSeq{ 3,4,5 }.map( function ( v ) return v + 1 end ) )
        .evaluate

    assert( o[1] == 1 )
    assert( o[2] == 2 )
    assert( o[3] == 3 )
    assert( o[4] == 4 )
    assert( o[5] == 5 )
    assert( o[6] == 6 )
end

function test_concatShouldWorkWithEmptySeq()
    local o = seq.toSeq{ 1,2,3 }.concat( seq.empty() ).evaluate

    assert( o[1] == 1 )
    assert( o[2] == 2 )
    assert( o[3] == 3 )
    assert( o[4] == nil )

    o = seq.toSeq{}.concat( seq.toSeq{ 1,2,3 } ).evaluate

    assert( o[1] == 1 )
    assert( o[2] == 2 )
    assert( o[3] == 3 )
    assert( o[4] == nil )
end

function test_concatShouldWorkWithScalar()
    local o = seq.toSeq{ 1,2,3 }.concat( "string" ).evaluate

    assert( o[1] == 1 )
    assert( o[2] == 2 )
    assert( o[3] == 3 )
    assert( o[4] == "string" ) 
end

-- This is basically a hack, but it's a valid use case.
-- It would be easier to get the expected behavior with a type system.
-- For now I'm just going to use this hack if I need list of list 
-- behavior.
function test_concatShouldAllowListAsScalarHack()
    local o = seq.toSeq{ 1,2,3 }.concat{ { 4,5,6 } }.evaluate

    assert( o[1] == 1 )
    assert( o[2] == 2 )
    assert( o[3] == 3 )
    assert( o[4][1] == 4 )
    assert( o[4][2] == 5 )
    assert( o[4][3] == 6 )
end

function test_dropCorrectNumberOfItems()
    local o = seq.toSeq{ 1,2,3,4,5,6 }.drop( 3 ).evaluate

    assert( o[0] == nil )
    assert( o[1] == 4 )
    assert( o[2] == 5 )
    assert( o[3] == 6 )
    assert( o[4] == nil )
end

function test_dropZeroItems() 
    local o = seq.toSeq{ 1,2,3 }.drop( 0 ).evaluate

    assert( o[1] == 1 )
    assert( o[2] == 2 )
    assert( o[3] == 3 )
end

function test_dropMoreItemsThanExistResultsInEmptySeq() 
    local o = seq.toSeq{ 1,2,3 }.drop( 10 ).evaluate

    assert( o[1] == nil )
end

function test_dropFromEmptySeqWorks() 
    local o = seq.toSeq{}.drop( 1 ).evaluate

    assert( o[1] == nil )
end

function test_takeCorrectNumberOfItems()
    local o = seq.toSeq{ 1,2,3,4,5,6 }.take( 3 ).evaluate

    assert( o[0] == nil )
    assert( o[1] == 1 )
    assert( o[2] == 2 )
    assert( o[3] == 3 )
    assert( o[4] == nil )
end

function test_takeZeroItemsCorrectly()
    local o = seq.toSeq{ 1,2,3 }.take( 0 ).evaluate

    assert( o[1] == nil )
end

function test_takeFromEmptySeqCorrectly()
    local o = seq.toSeq{}.take( 1 ).evaluate

    assert( o[1] == nil )
end

function test_takeMoreItemsThanExistWorks()
    local o = seq.toSeq{ 1,2,3 }.take( 10 ).evaluate

    assert( o[1] == 1 )
    assert( o[2] == 2 )
    assert( o[3] == 3 )
    assert( o[4] == nil )
end

function test_dropWhileShouldHandleEmptySeq()
    local o = seq.empty().dropWhile( function (x) return false end ).evaluate

    assert( o[1] == nil )
end

function test_dropWhileShouldDropWhilePredicateIsTrue()
    local o = seq.toSeq{ 1,3,5,7,8,10,11,12 }.dropWhile( function (n) return n % 2 == 1 end ).evaluate

    assert( o[1] == 8 )
    assert( o[2] == 10 )
    assert( o[3] == 11 )
    assert( o[4] == 12 )
end

function test_dropWhileShouldHandleAlwaysTrue()
    local o = seq.toSeq{ 1,3,5,7,8,10,11,12 }.dropWhile( function (n) return true end ).evaluate

    assert( o[1] == nil )
end

function test_dropWhileShouldHandleAlwaysFalse()
    local o = seq.toSeq{ 1,3,5,7,8,10,11,12 }.dropWhile( function (n) return false end ).evaluate

    assert( o[1] == 1 )
    assert( o[2] == 3 )
    assert( o[3] == 5 )
    assert( o[4] == 7 )
    assert( o[5] == 8 )
    assert( o[6] == 10 )
    assert( o[7] == 11 )
    assert( o[8] == 12 )
end
