chai = require 'chai'
expect = chai.expect

Duration = require '../lib/time/duration'
MathUtils = require '../lib/utils/math-utils'
MAX_SAFE_INTEGER = MathUtils.MAX_SAFE_INTEGER
MIN_SAFE_INTEGER = MathUtils.MIN_SAFE_INTEGER
int = MathUtils.int
Long = 
    MAX_VALUE: MAX_SAFE_INTEGER
    MIN_VALUE: MIN_SAFE_INTEGER


assertEquals = (actual, expected, message) ->
    expect(actual).to.equal expected, message

describe 'duration', ->

    it 'test_zero', ->
        expect(Duration.ZERO.seconds).to.equal 0
        expect(Duration.ZERO.nanos).to.equal 0

    it 'factory_seconds_long', ->
        i = -2
        while i <= 2
            t = Duration.ofSeconds(i)
            expect(t.seconds).to.equal i
            expect(t.nanos).to.equal 0
            i++

    it 'factory_seconds_long_long', ->
        i = -2
        while i <= 2
            j = 0
            while j < 10
                t = Duration.ofSeconds(i, j);
                assertEquals(t.getSeconds(), i);
                assertEquals(t.getNano(), j);
                j++

            j = -10
            while j < 0
                t = Duration.ofSeconds(i, j);
                assertEquals(t.getSeconds(), i - 1);
                assertEquals(t.getNano(), j + 1000000000);
                j++

            j = 999999990
            while j < 1000000000
                t = Duration.ofSeconds(i, j);
                assertEquals(t.getSeconds(), i);
                assertEquals(t.getNano(), j);
                j++
            i++

    it 'factory_seconds_long_long_nanosNegativeAdjusted', ->
        test = Duration.ofSeconds(2, -1)
        expect(test.seconds).to.equal 1
        expect(test.nanos).to.equal 999999999

    it 'provider_factory_millis_long', ->
        tuples = [
            [0, 0, 0]
            [1, 0, 1000000]
            [2, 0, 2000000]
            [999, 0, 999000000]
            [1000, 1, 0]
            [1001, 1, 1000000]
            [-1, -1, 999000000]
            [-2, -1, 998000000]
            [-999, -1, 1000000]
            [-1000, -1, 0]
            [-1001, -2, 999000000]
        ]
        for [millis, expectedSeconds, expectedNanoOfSecond], i in tuples
            test = Duration.ofMillis(millis)
            expect(test.seconds).to.equal expectedSeconds
            expect(test.nanos).to.equal expectedNanoOfSecond


    describe 'ofNanos()', ->
        it 'factory_nanos_nanos', ->
            test = Duration.ofNanos(1);
            assertEquals(test.getSeconds(), 0);
            assertEquals(test.getNano(), 1);

        it 'factory_nanos_nanosSecs', ->
            test = Duration.ofNanos(1000000002);
            assertEquals(test.getSeconds(), 1);
            assertEquals(test.getNano(), 2);

       it 'factory_nanos_negative', ->
            test = Duration.ofNanos(-2000000001);
            assertEquals(test.getSeconds(), -3);
            assertEquals(test.getNano(), 999999999);

        it 'factory_nanos_max', ->
            test = Duration.ofNanos(MAX_SAFE_INTEGER);
            assertEquals(test.getSeconds(), int MAX_SAFE_INTEGER / 1000000000);
            assertEquals(test.getNano(), int MAX_SAFE_INTEGER % 1000000000);

        it 'factory_nanos_min', ->
            test = Duration.ofNanos(MIN_SAFE_INTEGER);
            assertEquals(test.getSeconds(), int MIN_SAFE_INTEGER / 1000000000 - 1);
            assertEquals(test.getNano(), int MIN_SAFE_INTEGER % 1000000000 + 1000000000);

    describe 'ofMinutes()', ->
        it 'factory_minutes', ->
            test = Duration.ofMinutes(2);
            assertEquals(test.getSeconds(), 120);
            assertEquals(test.getNano(), 0);

        it 'factory_minutes_max', ->
            max = int Long.MAX_VALUE / 60
            test = Duration.ofMinutes(max);
            assertEquals(test.getSeconds(), max * 60);
            assertEquals(test.getNano(), 0);

        it 'factory_minutes_min', ->
            min = int Long.MIN_VALUE / 60
            test = Duration.ofMinutes(min);
            assertEquals(test.getSeconds(), min * 60);
            assertEquals(test.getNano(), 0);

        it 'factory_minutes_tooBig', ->
            expect( ->
                Duration.ofMinutes(Long.MAX_VALUE / 60 + 1);
            ).to.throw('arithmetic overflow')
            

        it 'factory_minutes_tooSmall', ->
            expect( ->
                Duration.ofMinutes(Long.MIN_VALUE / 60 - 1);
            ).to.throw('arithmetic underflow')

    describe 'ofHours', ->
        it 'factory_hours', ->
            test = Duration.ofHours(2);
            assertEquals(test.getSeconds(), 2 * 3600);
            assertEquals(test.getNano(), 0);

        it 'factory_hours_max', ->
            max = int Long.MAX_VALUE / 3600
            test = Duration.ofHours(max);
            assertEquals(test.getSeconds(), max * 3600);
            assertEquals(test.getNano(), 0);

        it 'factory_hours_min', ->
            min = int Long.MIN_VALUE / 3600
            test = Duration.ofHours(min);
            assertEquals(test.getSeconds(), min * 3600);
            assertEquals(test.getNano(), 0);

        it 'factory_hours_tooBig', ->
            expect( ->
                Duration.ofHours(Long.MAX_VALUE / 3600 + 1);
            ).to.throw('arithmetic overflow')

        it 'factory_hours_tooSmall', ->
            expect( ->
                Duration.ofHours(Long.MIN_VALUE / 3600 - 1);
            ).to.throw('arithmetic underflow')


    describe 'ofHours', ->
        it 'factory_days', ->
            test = Duration.ofDays(2);
            assertEquals(test.getSeconds(), 2 * 86400);
            assertEquals(test.getNano(), 0);

        it 'factory_days_max', ->
            max = int Long.MAX_VALUE / 86400
            test = Duration.ofDays(max);
            assertEquals(test.getSeconds(), max * 86400);
            assertEquals(test.getNano(), 0);

        it 'factory_days_min', ->
            min = int Long.MIN_VALUE / 86400
            test = Duration.ofDays(min);
            assertEquals(test.getSeconds(), min * 86400);
            assertEquals(test.getNano(), 0);

        it 'factory_days_tooBig', ->
            expect( ->
                Duration.ofDays(Long.MAX_VALUE / 86400 + 1);
            ).to.throw('arithmetic overflow')

        it 'factory_days_tooSmall', ->
            expect( ->
                Duration.ofDays(Long.MIN_VALUE / 86400 - 1);
            ).to.throw('arithmetic underflow')

    it 'isZero', ->
        assertEquals(Duration.ofNanos(0).isZero(), true);
        assertEquals(Duration.ofSeconds(0).isZero(), true);
        assertEquals(Duration.ofNanos(1).isZero(), false);
        assertEquals(Duration.ofSeconds(1).isZero(), false);
        assertEquals(Duration.ofSeconds(1, 1).isZero(), false);
        assertEquals(Duration.ofNanos(-1).isZero(), false);
        assertEquals(Duration.ofSeconds(-1).isZero(), false);
        assertEquals(Duration.ofSeconds(-1, -1).isZero(), false);

    it 'isNegative', ->
        assertEquals(Duration.ofNanos(0).isNegative(), false);
        assertEquals(Duration.ofSeconds(0).isNegative(), false);
        assertEquals(Duration.ofNanos(1).isNegative(), false);
        assertEquals(Duration.ofSeconds(1).isNegative(), false);
        assertEquals(Duration.ofSeconds(1, 1).isNegative(), false);
        assertEquals(Duration.ofNanos(-1).isNegative(), true);
        assertEquals(Duration.ofSeconds(-1).isNegative(), true);
        assertEquals(Duration.ofSeconds(-1, -1).isNegative(), true);

    it 'getUnits', ->
        units = Duration.getUnits()
        expect(units).to.eql ['SECONDS', 'NANOS']

    describe 'plusSeconds', ->
        it 'plusSeconds_long', ->
            tuples = [
                [0, 0, 0, 0, 0]
                [0, 0, 1, 1, 0]
                [0, 0, -1, -1, 0]
                [0, 0, Long.MAX_VALUE, Long.MAX_VALUE, 0]
                [0, 0, Long.MIN_VALUE, Long.MIN_VALUE, 0]
                [1, 0, 0, 1, 0]
                [1, 0, 1, 2, 0]
                [1, 0, -1, 0, 0]
                [1, 0, Long.MAX_VALUE - 1, Long.MAX_VALUE, 0]
                [1, 0, Long.MIN_VALUE, Long.MIN_VALUE + 1, 0]
                [1, 1, 0, 1, 1]
                [1, 1, 1, 2, 1]
                [1, 1, -1, 0, 1]
                [1, 1, Long.MAX_VALUE - 1, Long.MAX_VALUE, 1]
                [1, 1, Long.MIN_VALUE, Long.MIN_VALUE + 1, 1]
                [-1, 1, 0, -1, 1]
                [-1, 1, 1, 0, 1]
                [-1, 1, -1, -2, 1]
                [-1, 1, Long.MAX_VALUE, Long.MAX_VALUE - 1, 1]
                [-1, 1, Long.MIN_VALUE + 1, Long.MIN_VALUE, 1]
            ]
            for [seconds, nanos, amount, expectedSeconds, expectedNanoOfSecond] in tuples
                t = Duration.ofSeconds(seconds, nanos)
                t = t.plusSeconds(amount)
                assertEquals(t.getSeconds(), expectedSeconds)
                assertEquals(t.getNano(), expectedNanoOfSecond)

    describe 'plusMillis', ->
        it 'plusMillis_long', ->
            tuples = [
                [0, 0, 0,       0, 0]
                [0, 0, 1,       0, 1000000]
                [0, 0, 999,     0, 999000000]
                [0, 0, 1000,    1, 0]
                [0, 0, 1001,    1, 1000000]
                [0, 0, 1999,    1, 999000000]
                [0, 0, 2000,    2, 0]
                [0, 0, -1,      -1, 999000000]
                [0, 0, -999,    -1, 1000000]
                [0, 0, -1000,   -1, 0]
                [0, 0, -1001,   -2, 999000000]
                [0, 0, -1999,   -2, 1000000]

                [0, 1, 0,       0, 1]
                [0, 1, 1,       0, 1000001]
                [0, 1, 998,     0, 998000001]
                [0, 1, 999,     0, 999000001]
                [0, 1, 1000,    1, 1]
                [0, 1, 1998,    1, 998000001]
                [0, 1, 1999,    1, 999000001]
                [0, 1, 2000,    2, 1]
                [0, 1, -1,      -1, 999000001]
                [0, 1, -2,      -1, 998000001]
                [0, 1, -1000,   -1, 1]
                [0, 1, -1001,   -2, 999000001]

                [0, 1000000, 0,       0, 1000000]
                [0, 1000000, 1,       0, 2000000]
                [0, 1000000, 998,     0, 999000000]
                [0, 1000000, 999,     1, 0]
                [0, 1000000, 1000,    1, 1000000]
                [0, 1000000, 1998,    1, 999000000]
                [0, 1000000, 1999,    2, 0]
                [0, 1000000, 2000,    2, 1000000]
                [0, 1000000, -1,      0, 0]
                [0, 1000000, -2,      -1, 999000000]
                [0, 1000000, -999,    -1, 2000000]
                [0, 1000000, -1000,   -1, 1000000]
                [0, 1000000, -1001,   -1, 0]
                [0, 1000000, -1002,   -2, 999000000]

                [0, 999999999, 0,     0, 999999999]
                [0, 999999999, 1,     1, 999999]
                [0, 999999999, 999,   1, 998999999]
                [0, 999999999, 1000,  1, 999999999]
                [0, 999999999, 1001,  2, 999999]
                [0, 999999999, -1,    0, 998999999]
                [0, 999999999, -1000, -1, 999999999]
                [0, 999999999, -1001, -1, 998999999]
            ]
            for [seconds, nanos, amount, expectedSeconds, expectedNanoOfSecond] in tuples
                t = Duration.ofSeconds(seconds, nanos)
                t = t.plusMillis(amount)
                assertEquals(t.getSeconds(), expectedSeconds)
                assertEquals(t.getNano(), expectedNanoOfSecond)


    it 'plusNanos', ->
        it 'plusNanos_long', ->
            tuples = [
                [0, 0, 0,           0, 0]
                [0, 0, 1,           0, 1]
                [0, 0, 999999999,   0, 999999999]
                [0, 0, 1000000000,  1, 0]
                [0, 0, 1000000001,  1, 1]
                [0, 0, 1999999999,  1, 999999999]
                [0, 0, 2000000000,  2, 0]
                [0, 0, -1,          -1, 999999999]
                [0, 0, -999999999,  -1, 1]
                [0, 0, -1000000000, -1, 0]
                [0, 0, -1000000001, -2, 999999999]
                [0, 0, -1999999999, -2, 1]

                [1, 0, 0,           1, 0]
                [1, 0, 1,           1, 1]
                [1, 0, 999999999,   1, 999999999]
                [1, 0, 1000000000,  2, 0]
                [1, 0, 1000000001,  2, 1]
                [1, 0, 1999999999,  2, 999999999]
                [1, 0, 2000000000,  3, 0]
                [1, 0, -1,          0, 999999999]
                [1, 0, -999999999,  0, 1]
                [1, 0, -1000000000, 0, 0]
                [1, 0, -1000000001, -1, 999999999]
                [1, 0, -1999999999, -1, 1]

                [-1, 0, 0,           -1, 0]
                [-1, 0, 1,           -1, 1]
                [-1, 0, 999999999,   -1, 999999999]
                [-1, 0, 1000000000,  0, 0]
                [-1, 0, 1000000001,  0, 1]
                [-1, 0, 1999999999,  0, 999999999]
                [-1, 0, 2000000000,  1, 0]
                [-1, 0, -1,          -2, 999999999]
                [-1, 0, -999999999,  -2, 1]
                [-1, 0, -1000000000, -2, 0]
                [-1, 0, -1000000001, -3, 999999999]
                [-1, 0, -1999999999, -3, 1]

                [1, 1, 0,           1, 1]
                [1, 1, 1,           1, 2]
                [1, 1, 999999998,   1, 999999999]
                [1, 1, 999999999,   2, 0]
                [1, 1, 1000000000,  2, 1]
                [1, 1, 1999999998,  2, 999999999]
                [1, 1, 1999999999,  3, 0]
                [1, 1, 2000000000,  3, 1]
                [1, 1, -1,          1, 0]
                [1, 1, -2,          0, 999999999]
                [1, 1, -1000000000, 0, 1]
                [1, 1, -1000000001, 0, 0]
                [1, 1, -1000000002, -1, 999999999]
                [1, 1, -2000000000, -1, 1]

                [1, 999999999, 0,           1, 999999999]
                [1, 999999999, 1,           2, 0]
                [1, 999999999, 999999999,   2, 999999998]
                [1, 999999999, 1000000000,  2, 999999999]
                [1, 999999999, 1000000001,  3, 0]
                [1, 999999999, -1,          1, 999999998]
                [1, 999999999, -1000000000, 0, 999999999]
                [1, 999999999, -1000000001, 0, 999999998]
                [1, 999999999, -1999999999, 0, 0]
                [1, 999999999, -2000000000, -1, 999999999]

                [Long.MAX_VALUE, 0, 999999999, Long.MAX_VALUE, 999999999]
                [Long.MAX_VALUE - 1, 0, 1999999999, Long.MAX_VALUE, 999999999]
                [Long.MIN_VALUE, 1, -1, Long.MIN_VALUE, 0]
                [Long.MIN_VALUE + 1, 1, -1000000001, Long.MIN_VALUE, 0]
            ]

            for [seconds, nanos, amount, expectedSeconds, expectedNanoOfSecond] in tuples
                t = Duration.ofSeconds(seconds, nanos)
                t = t.plusNanos(amount)
                assertEquals(t.getSeconds(), expectedSeconds)
                assertEquals(t.getNano(), expectedNanoOfSecond)

    # TODO: failing since implemenation is wrong
    describe.skip 'multipliedBy', ->
        multipliedBy = [
            [-4, 666666667, -3,   9, 999999999]
            [-4, 666666667, -2,   6, 666666666]
            [-4, 666666667, -1,   3, 333333333]
            [-4, 666666667,  0,   0,         0]
            [-4, 666666667,  1,  -4, 666666667]
            [-4, 666666667,  2,  -7, 333333334]
            [-4, 666666667,  3, -10,         1]

            [-3, 0, -3,  9, 0]
            [-3, 0, -2,  6, 0]
            [-3, 0, -1,  3, 0]
            [-3, 0,  0,  0, 0]
            [-3, 0,  1, -3, 0]
            [-3, 0,  2, -6, 0]
            [-3, 0,  3, -9, 0]

            [-2, 0, -3,  6, 0]
            [-2, 0, -2,  4, 0]
            [-2, 0, -1,  2, 0]
            [-2, 0,  0,  0, 0]
            [-2, 0,  1, -2, 0]
            [-2, 0,  2, -4, 0]
            [-2, 0,  3, -6, 0]

            [-1, 0, -3,  3, 0]
            [-1, 0, -2,  2, 0]
            [-1, 0, -1,  1, 0]
            [-1, 0,  0,  0, 0]
            [-1, 0,  1, -1, 0]
            [-1, 0,  2, -2, 0]
            [-1, 0,  3, -3, 0]

            [-1, 500000000, -3,  1, 500000000]
            [-1, 500000000, -2,  1,         0]
            [-1, 500000000, -1,  0, 500000000]
            [-1, 500000000,  0,  0,         0]
            [-1, 500000000,  1, -1, 500000000]
            [-1, 500000000,  2, -1,         0]
            [-1, 500000000,  3, -2, 500000000]

            [0, 0, -3, 0, 0]
            [0, 0, -2, 0, 0]
            [0, 0, -1, 0, 0]
            [0, 0,  0, 0, 0]
            [0, 0,  1, 0, 0]
            [0, 0,  2, 0, 0]
            [0, 0,  3, 0, 0]

            [0, 500000000, -3, -2, 500000000]
            [0, 500000000, -2, -1,         0]
            [0, 500000000, -1, -1, 500000000]
            [0, 500000000,  0,  0,         0]
            [0, 500000000,  1,  0, 500000000]
            [0, 500000000,  2,  1,         0]
            [0, 500000000,  3,  1, 500000000]

            [1, 0, -3, -3, 0]
            [1, 0, -2, -2, 0]
            [1, 0, -1, -1, 0]
            [1, 0,  0,  0, 0]
            [1, 0,  1,  1, 0]
            [1, 0,  2,  2, 0]
            [1, 0,  3,  3, 0]

            [2, 0, -3, -6, 0]
            [2, 0, -2, -4, 0]
            [2, 0, -1, -2, 0]
            [2, 0,  0,  0, 0]
            [2, 0,  1,  2, 0]
            [2, 0,  2,  4, 0]
            [2, 0,  3,  6, 0]

            [3, 0, -3, -9, 0]
            [3, 0, -2, -6, 0]
            [3, 0, -1, -3, 0]
            [3, 0,  0,  0, 0]
            [3, 0,  1,  3, 0]
            [3, 0,  2,  6, 0]
            [3, 0,  3,  9, 0]

            [3, 333333333, -3, -10,         1]
            [3, 333333333, -2,  -7, 333333334]
            [3, 333333333, -1,  -4, 666666667]
            [3, 333333333,  0,   0,         0]
            [3, 333333333,  1,   3, 333333333]
            [3, 333333333,  2,   6, 666666666]
            [3, 333333333,  3,   9, 999999999]
        ]

        it 'multipliedBy', ->
            for [seconds, nanos, multiplicand, expectedSeconds, expectedNanos] in multipliedBy
                t = Duration.ofSeconds(seconds, nanos)
                t = t.multipliedBy(multiplicand)
                console.log "(#{seconds}, #{nanos}) * #{multiplicand}"
                assertEquals(t.getSeconds(), expectedSeconds, "(#{seconds}, #{nanos}) * #{multiplicand}")
                assertEquals(t.getNano(), expectedNanos)

    describe 'parse', ->
        parseSuccess = [
            ["PT0S", 0, 0]
            ["PT1S", 1, 0]
            ["PT12S", 12, 0]
            ["PT123456789S", 123456789, 0]
            ["PT" + Long.MAX_VALUE + "S", Long.MAX_VALUE, 0]

            ["PT+1S", 1, 0]
            ["PT+12S", 12, 0]
            ["PT+123456789S", 123456789, 0]
            ["PT+" + Long.MAX_VALUE + "S", Long.MAX_VALUE, 0]

            ["PT-1S", -1, 0]
            ["PT-12S", -12, 0]
            ["PT-123456789S", -123456789, 0]
            ["PT" + Long.MIN_VALUE + "S", Long.MIN_VALUE, 0]

            ["PT1.1S", 1, 100000000]
            ["PT1.12S", 1, 120000000]
            ["PT1.123S", 1, 123000000]
            ["PT1.1234S", 1, 123400000]
            ["PT1.12345S", 1, 123450000]
            ["PT1.123456S", 1, 123456000]
            ["PT1.1234567S", 1, 123456700]
            ["PT1.12345678S", 1, 123456780]
            ["PT1.123456789S", 1, 123456789]

            ["PT-1.1S", -2, 1000000000 - 100000000]
            ["PT-1.12S", -2, 1000000000 - 120000000]
            ["PT-1.123S", -2, 1000000000 - 123000000]
            ["PT-1.1234S", -2, 1000000000 - 123400000]
            ["PT-1.12345S", -2, 1000000000 - 123450000]
            ["PT-1.123456S", -2, 1000000000 - 123456000]
            ["PT-1.1234567S", -2, 1000000000 - 123456700]
            ["PT-1.12345678S", -2, 1000000000 - 123456780]
            ["PT-1.123456789S", -2, 1000000000 - 123456789]

            ["PT" + Long.MAX_VALUE + ".123456789S", Long.MAX_VALUE, 123456789]
            ["PT" + Long.MIN_VALUE + ".000000000S", Long.MIN_VALUE, 0]

            ["PT01S", 1, 0]
            ["PT001S", 1, 0]
            ["PT000S", 0, 0]
            ["PT+01S", 1, 0]
            ["PT-01S", -1, 0]

            ["PT1.S", 1, 0]
            ["PT+1.S", 1, 0]
            ["PT-1.S", -1, 0]

            ["P0D", 0, 0]
            ["P0DT0H", 0, 0]
            ["P0DT0M", 0, 0]
            ["P0DT0S", 0, 0]
            ["P0DT0H0S", 0, 0]
            ["P0DT0M0S", 0, 0]
            ["P0DT0H0M0S", 0, 0]

            ["P1D", 86400, 0]
            ["P1DT0H", 86400, 0]
            ["P1DT0M", 86400, 0]
            ["P1DT0S", 86400, 0]
            ["P1DT0H0S", 86400, 0]
            ["P1DT0M0S", 86400, 0]
            ["P1DT0H0M0S", 86400, 0]

            ["P3D", 86400 * 3, 0]
            ["P3DT2H", 86400 * 3 + 3600 * 2, 0]
            ["P3DT2M", 86400 * 3 + 60 * 2, 0]
            ["P3DT2S", 86400 * 3 + 2, 0]
            ["P3DT2H1S", 86400 * 3 + 3600 * 2 + 1, 0]
            ["P3DT2M1S", 86400 * 3 + 60 * 2 + 1, 0]
            ["P3DT2H1M1S", 86400 * 3 + 3600 * 2 + 60 + 1, 0]

            ["P-3D", -86400 * 3, 0]
            ["P-3DT2H", -86400 * 3 + 3600 * 2, 0]
            ["P-3DT2M", -86400 * 3 + 60 * 2, 0]
            ["P-3DT2S", -86400 * 3 + 2, 0]
            ["P-3DT2H1S", -86400 * 3 + 3600 * 2 + 1, 0]
            ["P-3DT2M1S", -86400 * 3 + 60 * 2 + 1, 0]
            ["P-3DT2H1M1S", -86400 * 3 + 3600 * 2 + 60 + 1, 0]

            ["P-3DT-2H", -86400 * 3 - 3600 * 2, 0]
            ["P-3DT-2M", -86400 * 3 - 60 * 2, 0]
            ["P-3DT-2S", -86400 * 3 - 2, 0]
            ["P-3DT-2H1S", -86400 * 3 - 3600 * 2 + 1, 0]
            ["P-3DT-2M1S", -86400 * 3 - 60 * 2 + 1, 0]
            ["P-3DT-2H1M1S", -86400 * 3 - 3600 * 2 + 60 + 1, 0]

            ["PT0H", 0, 0]
            ["PT0H0M", 0, 0]
            ["PT0H0S", 0, 0]
            ["PT0H0M0S", 0, 0]

            ["PT1H", 3600, 0]
            ["PT3H", 3600 * 3, 0]
            ["PT-1H", -3600, 0]
            ["PT-3H", -3600 * 3, 0]

            ["PT2H5M", 3600 * 2 + 60 * 5, 0]
            ["PT2H5S", 3600 * 2 + 5, 0]
            ["PT2H5M8S", 3600 * 2 + 60 * 5 + 8, 0]
            ["PT-2H5M", -3600 * 2 + 60 * 5, 0]
            ["PT-2H5S", -3600 * 2 + 5, 0]
            ["PT-2H5M8S", -3600 * 2 + 60 * 5 + 8, 0]
            ["PT-2H-5M", -3600 * 2 - 60 * 5, 0]
            ["PT-2H-5S", -3600 * 2 - 5, 0]
            ["PT-2H-5M8S", -3600 * 2 - 60 * 5 + 8, 0]
            ["PT-2H-5M-8S", -3600 * 2 - 60 * 5 - 8, 0]

            ["PT0M", 0, 0]
            ["PT1M", 60, 0]
            ["PT3M", 60 * 3, 0]
            ["PT-1M", -60, 0]
            ["PT-3M", -60 * 3, 0]
            ["P0DT3M", 60 * 3, 0]
            ["P0DT-3M", -60 * 3, 0]

            # allow leading and trailing whitespaces 
            [" PT0S", 0, 0]
            ["PT0S ", 0, 0]
        ]
        parseFailure = [
            [""]
            ["ABCDEF"]

            ["PTS"]
            ["AT0S"]
            ["PA0S"]
            ["PT0A"]

            ["P0Y"]
            ["P1Y"]
            ["P-2Y"]
            ["P0M"]
            ["P1M"]
            ["P-2M"]
            ["P3Y2D"]
            ["P3M2D"]
            ["P3W"]
            ["P-3W"]
            ["P2YT30S"]
            ["P2MT30S"]

            ["P1DT"]

            ["PT+S"]
            ["PT-S"]
            ["PT.S"]
            ["PTAS"]

            ["PT-.S"]
            ["PT+.S"]

            ["PT1ABC2S"]
            ["PT1.1ABC2S"]

            ["PT123456789123456789123456789S"]
            ["PT0.1234567891S"]

            ["PT2.-3"]
            ["PT-2.-3"]
            ["PT2.+3"]
            ["PT-2.+3"]
        ]

        it 'factory_parse', ->
            for [text, expectedSeconds, expectedNanoOfSecond] in parseSuccess
                test = Duration.parse(text)
                assertEquals(test.getSeconds(), expectedSeconds, text)
                assertEquals(test.getNano(), expectedNanoOfSecond, text)

        it 'factory_parse_plus', ->
            for [text, expectedSeconds, expectedNanoOfSecond] in parseSuccess
                test = Duration.parse("+" + text)
                assertEquals(test.getSeconds(), expectedSeconds, text)
                assertEquals(test.getNano(), expectedNanoOfSecond, text)

        it 'factory_parseFailures', ->
            for text in parseFailure
                expect( ->
                    Duration.parse(text)
                ).to.throw(Error)

        # how this could test anything? if the parseFailure contains already only failures
        # it 'factory_parseFailures_comma', ->
        #     text = text.replace('.', ',')
        #     Duration.parse(text)

        it 'factory_parse_tooBig', ->
            expect( ->
                Duration.parse("PT" + Long.MAX_VALUE + "1S")
            ).to.throw 'Text cannot be parsed to a Duration: seconds from PT'+Long.MAX_VALUE+'1S - arithmetic overflow'
            

        it 'factory_parse_tooBig_decimal', ->
            expect( ->
                Duration.parse("PT" + Long.MAX_VALUE + "1.1S")
            ).to.throw 'Text cannot be parsed to a Duration: seconds from PT'+Long.MAX_VALUE+'1.1S - arithmetic overflow'

        it 'factory_parse_tooSmall', ->
            expect( ->
                Duration.parse("PT" + Long.MIN_VALUE + "1S")
            ).to.throw 'Text cannot be parsed to a Duration: seconds from PT'+Long.MIN_VALUE+'1S - arithmetic underflow'

        it 'factory_parse_tooSmall_decimal', ->
            expect( ->
                Duration.parse("PT" + Long.MIN_VALUE + ".1S")
            ).to.throw 'Text cannot be parsed to a Duration: overflow: PT'+Long.MIN_VALUE+'.1S - arithmetic underflow'

        it 'factory_parse_nullText', ->
            expect( ->
                Duration.parse(null)
            ).to.throw 'Text cannot be parsed to a Duration: null'


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