
require 'seq'
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
