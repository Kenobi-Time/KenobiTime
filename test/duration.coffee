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


assertEquals = (actual, expected) ->
    expect(actual).to.equal expected

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

    it.skip 'factory_seconds_long_long', ->

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