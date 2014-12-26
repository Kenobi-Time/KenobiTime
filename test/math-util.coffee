chai = require 'chai'
expect = chai.expect

Big = require 'big.js'

MathUtils = require '../lib/utils/math-utils'
MAX_SAFE_INTEGER = MathUtils.MAX_SAFE_INTEGER
MIN_SAFE_INTEGER = MathUtils.MIN_SAFE_INTEGER

describe 'MathUtils', ->

    it 'too big integers', ->
        max = MAX_SAFE_INTEGER
        x = max + 1
        y = max + 2
        # this is not equal actually, but this is an unsafe int
        # and you cannot rely on its calculations
        expect(x).to.equal y

        a = new Big(max).plus(1).toFixed()
        b = new Big(max).plus(2).toFixed()
        expect(a).not.equal b


    it 'addExact', ->
        tuples = [
            [0, 0, 0]
            [1, 0, 1]
            [0, 1, 1]
            [1, 1, 2]
            [-1, 1, 0]
            [1 , -1, 0]
            [1000, 2000, 3000]

            [MAX_SAFE_INTEGER, 1, 'arithmetic overflow']
            [MIN_SAFE_INTEGER, 1, MIN_SAFE_INTEGER + 1]
            [MAX_SAFE_INTEGER, 2, 'arithmetic overflow']
            [MIN_SAFE_INTEGER, 2, MIN_SAFE_INTEGER + 2]
            [MAX_SAFE_INTEGER, -1, MAX_SAFE_INTEGER - 1]
            [MIN_SAFE_INTEGER, -1, 'arithmetic underflow']
            [MAX_SAFE_INTEGER, -2, MAX_SAFE_INTEGER - 2]
            [MIN_SAFE_INTEGER, -2, 'arithmetic underflow']
        ]

        for [x, y, expected], i in tuples
            if typeof expected is 'string'
                expect(->
                    MathUtils.addExact x, y
                , "#{x} + #{y}").to.throw expected
            else
                result = MathUtils.addExact x, y
                expect(result).to.equal expected, "#{x} + #{y}"

    it 'multiplyExact', ->
        tuples = [
            [0, 0, 0]
            [1, 0, 0]
            [0, 1, 0]
            [1, 1, 1]
            [-1, 1, -1]
            [1 , -1, -1]
            [1000, 2000, 2000000]

            [MAX_SAFE_INTEGER, MAX_SAFE_INTEGER, 'arithmetic overflow']
            [MIN_SAFE_INTEGER, MIN_SAFE_INTEGER, 'arithmetic overflow']
            [MAX_SAFE_INTEGER, 1, MAX_SAFE_INTEGER]
            [MIN_SAFE_INTEGER, 1, MIN_SAFE_INTEGER]
            [MAX_SAFE_INTEGER, 2, 'arithmetic overflow']
            [MIN_SAFE_INTEGER, 2, 'arithmetic underflow']
            [MAX_SAFE_INTEGER, -1, -1 * MAX_SAFE_INTEGER]
            [MIN_SAFE_INTEGER, -1, -1 * MIN_SAFE_INTEGER]
            [MAX_SAFE_INTEGER, -2, 'arithmetic underflow']
            [MIN_SAFE_INTEGER, -2, 'arithmetic overflow']

        ]
        for [x, y, expected], i in tuples
            if typeof expected is 'string'
                expect(->
                    MathUtils.multiplyExact x, y
                , "#{x} * #{y}").to.throw expected
            else
                result = MathUtils.multiplyExact x, y
                expect(result).to.equal expected, "#{x} * #{y}"