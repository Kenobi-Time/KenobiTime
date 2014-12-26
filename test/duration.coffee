chai = require 'chai'
expect = chai.expect

Duration = require '../lib/time/duration'
MathUtils = require '../lib/utils/math-utils'
MAX_SAFE_INTEGER = MathUtils.MAX_SAFE_INTEGER
MIN_SAFE_INTEGER = MathUtils.MIN_SAFE_INTEGER
Long = 
    MAX_VALUE: MAX_SAFE_INTEGER
    MIN_VALUE: MIN_SAFE_INTEGER


assertEquals = (actual, expected) ->
    expect(actual).to.equal expected

describe 'duration', ->

    it 'toString', ->
        toStringTuples = [
            [0, 0, "PT0S"]
            [0, 1, "PT0.000000001S"]
            [0, 10, "PT0.00000001S"]
            [0, 100, "PT0.0000001S"]
            [0, 1000, "PT0.000001S"]
            [0, 10000, "PT0.00001S"]
            [0, 100000, "PT0.0001S"]
            [0, 1000000, "PT0.001S"]
            [0, 10000000, "PT0.01S"]
            [0, 100000000, "PT0.1S"]
            [0, 120000000, "PT0.12S"]
            [0, 123000000, "PT0.123S"]
            [0, 123400000, "PT0.1234S"]
            [0, 123450000, "PT0.12345S"]
            [0, 123456000, "PT0.123456S"]
            [0, 123456700, "PT0.1234567S"]
            [0, 123456780, "PT0.12345678S"]
            [0, 123456789, "PT0.123456789S"]
            [1, 0, "PT1S"]
            [59, 0, "PT59S"]
            [60, 0, "PT1M"]
            [61, 0, "PT1M1S"]
            [3599, 0, "PT59M59S"]
            [3600, 0, "PT1H"]
            [3601, 0, "PT1H1S"]
            [3661, 0, "PT1H1M1S"]
            [86399, 0, "PT23H59M59S"]
            [86400, 0, "PT24H"]
            [59, 0, "PT59S"]
            [59, 0, "PT59S"]
            [-1, 0, "PT-1S"]
            [-1, 1000, "PT-0.999999S"]
            [-1, 900000000, "PT-0.1S"]
            [MathUtils.MAX_SAFE_INTEGER, 0, "PT" + parseInt(MathUtils.MAX_SAFE_INTEGER / 3600) + "H" + parseInt((MathUtils.MAX_SAFE_INTEGER % 3600) / 60) + "M" + parseInt(MathUtils.MAX_SAFE_INTEGER % 60) + "S"]
            [MathUtils.MIN_SAFE_INTEGER, 0, "PT" + parseInt(MathUtils.MIN_SAFE_INTEGER / 3600) + "H" + parseInt((MathUtils.MIN_SAFE_INTEGER % 3600) / 60) + "M" + parseInt(MathUtils.MIN_SAFE_INTEGER % 60) + "S"]
        ]
        for [seconds, nanos, expected] in toStringTuples
            result = Duration.create(seconds, nanos).toString()
            expect(result).to.equal expected, expected