Big = require 'big.js'
MathUtils = require '../utils/math-utils'
int = MathUtils.int
StringBuilder = require '../utils/string-builder'

LocalTime = require './local-time'

SECONDS_PER_DAY = LocalTime.SECONDS_PER_DAY
SECONDS_PER_HOUR = LocalTime.SECONDS_PER_HOUR
SECONDS_PER_MINUTE = LocalTime.SECONDS_PER_MINUTE
NANOS_PER_SECOND = LocalTime.NANOS_PER_SECOND

class Duration

    @PATTERN = new RegExp "([-+]?)P(?:([-+]?[0-9]+)D)?(T(?:([-+]?[0-9]+)H)?(?:([-+]?[0-9]+)M)?(?:([-+]?[0-9]+)(?:[.,]([0-9]{0,9}))?S)?)?", "i"
    @ZERO = new Duration(0, 0)

    @create = (seconds, nanoAdjustment) ->
        if (seconds | nanoAdjustment) is 0
            return @ZERO

        if seconds instanceof Big
            nanos = int seconds.mod(1).times(NANOS_PER_SECOND).toFixed(0)
            secs = int seconds.toFixed(0)
            MathUtils.checkSafeInt secs
            return @ofSeconds(secs, nanos)

        return new Duration(seconds, nanoAdjustment)

    @ofDays = (days) ->
        return @create(MathUtils.multiplyExact(days, SECONDS_PER_DAY), 0)

    @ofHours = (hours) ->
        return @create(MathUtils.multiplyExact(hours, SECONDS_PER_HOUR), 0)
    
    @ofMinutes = (minutes) ->
        return @create(MathUtils.multiplyExact(minutes, SECONDS_PER_MINUTE), 0)
    
    @ofSeconds = (seconds, nanoAdjustment) ->
        unless nanoAdjustment?
            return @create(seconds, 0)

        secs = MathUtils.addExact(seconds, MathUtils.floorDiv(nanoAdjustment, NANOS_PER_SECOND))
        nos = int MathUtils.floorMod(nanoAdjustment, NANOS_PER_SECOND)
        return @create(secs, nos)

    @ofMillis = (millis) ->
        secs = int millis / 1000
        mos = int millis % 1000
        if (mos < 0)
            mos += 1000
            secs--
        return @create(secs, mos * 1000000)

    @ofNanos = (nanos) ->
        secs = int nanos / NANOS_PER_SECOND
        nos = int nanos % NANOS_PER_SECOND
        if nos < 0
            nos += NANOS_PER_SECOND
            secs--
        return @create(secs, nos)

    @getUnits = ->
        return ['SECONDS', 'NANOS']

    @parse = (text) ->
        matcher = @PATTERN.exec(text)
        if matcher?
            # check for letter T but no time sections
            if ("T" is matcher[3]) is false
                negate = "-" is matcher[1]
                dayMatch = matcher[2]
                hourMatch = matcher[4]
                minuteMatch = matcher[5]
                secondMatch = matcher[6]
                fractionMatch = matcher[7]
                if dayMatch? or hourMatch? or minuteMatch? or secondMatch?
                    daysAsSecs = @_parseNumber(text, dayMatch, SECONDS_PER_DAY, "days")
                    hoursAsSecs = @_parseNumber(text, hourMatch, SECONDS_PER_HOUR, "hours")
                    minsAsSecs = @_parseNumber(text, minuteMatch, SECONDS_PER_MINUTE, "minutes")
                    seconds = @_parseNumber(text, secondMatch, 1, "seconds")
                    nanos = @_parseFraction(text,  fractionMatch, if seconds < 0 then -1 else 1)
                    try
                        return @_create(negate, daysAsSecs, hoursAsSecs, minsAsSecs, seconds, nanos)
                    catch err
                        throw new Error "Text cannot be parsed to a Duration: overflow: #{text} - #{err.message}"
        
        throw new Error "Text cannot be parsed to a Duration: #{text}"

    @_parseNumber = (text, parsed, multiplier, errorText) ->
        # regex limits to [-+]?[0-9]+
        unless parsed?
            return 0
        try
            val = int parsed
            return MathUtils.multiplyExact(val, multiplier)
        catch err
            throw new Error "Text cannot be parsed to a Duration: #{errorText} from #{text} - #{err.message}"

    @_parseFraction = (text, parsed, negate) ->
        #regex limits to [0-9]{0,9}
        if not parsed? or parsed.length is 0
            return 0
        try
            parsed = (parsed + "000000000").substring(0, 9)
            return int (parsed) * negate
        catch err
            throw new Error "Text cannot be parsed to a Duration: fraction: #{text} - #{err.message}"

    @_create = (negate, daysAsSecs, hoursAsSecs, minsAsSecs, secs, nanos) ->
        seconds = MathUtils.addExact(daysAsSecs, MathUtils.addExact(hoursAsSecs, MathUtils.addExact(minsAsSecs, secs)))
        if negate
            return @ofSeconds(seconds, nanos).negated()
        
        return @ofSeconds(seconds, nanos)


    constructor: (@seconds, @nanos) ->

    getSeconds: ->
        return @seconds

    getNano: ->
        return @nanos

    isZero: ->
        return (@seconds | @nanos) is 0

    isNegative: ->
        return @seconds < 0

    compare: (otherDuration) ->
        cmp = MathUtils.compare(seconds, otherDuration.seconds)
        if cmp isnt 0
            return cmp
        return nanos - otherDuration.nanos

    _toSeconds: ->
        if @seconds < 0
            @nanos *= -1
        return new Big(@seconds).plus(@nanos / (NANOS_PER_SECOND * 10))

    dividedBy: (divisor) ->
        if divisor is 0
            throw new Error 'Cannot divide by zero'
        
        if divisor is 1
            return this
        
        return Duration.createcreate(@_toSeconds().div(divisor, RoundingMode.DOWN))

    multipliedBy: (multiplicand) ->
        if multiplicand is 0
            return Duration.ZERO
        
        if multiplicand is 1
            return this

        return Duration.create(@_toSeconds().times(multiplicand))
        
    negated: ->
        return multipliedBy(-1)

    plus: (secondsToAdd, nanosToAdd) ->
        if secondsToAdd instanceof Duration
            duration = secondsToAdd
            return plus(duration.seconds, duration.nanos)

        if (secondsToAdd | nanosToAdd) is 0
            return this

        epochSec = MathUtils.addExact(@seconds, secondsToAdd)
        epochSec = MathUtils.addExact(epochSec, nanosToAdd / NANOS_PER_SECOND)
        nanosToAdd = nanosToAdd % NANOS_PER_SECOND
        nanoAdjustment = @nanos + nanosToAdd #safe int+NANOS_PER_SECOND
        return Duration.ofSeconds(epochSec, nanoAdjustment)

    plusSeconds: (secondsToAdd) ->
        return @plus(secondsToAdd, 0)

    plusMillis: (millisToAdd) ->
        return @plus(millisToAdd / 1000, (millisToAdd % 1000) * 1000000)

    plusNanos: (nanosToAdd) ->
        return @plus(0, nanosToAdd)

    toDays: ->
        return @seconds / SECONDS_PER_DAY

    toHours: ->
        return @seconds / SECONDS_PER_HOUR

    toMinutes: ->
        return @seconds / SECONDS_PER_MINUTE

    toMillis: ->
        millis = MathUtils.multiplyExact(@seconds, 1000)
        millis = MathUtils.addExact(millis, @nanos / 1000000)
        return millis
    
    toNanos: ->
        totalNanos = MathUtils.multiplyExact(@seconds, NANOS_PER_SECOND)
        totalNanos = MathUtils.addExact(totalNanos, @nanos)
        return totalNanos

    toString: ->
        if this is @ZERO
            return "PT0S"
        
        hours = parseInt @seconds / SECONDS_PER_HOUR
        minutes = parseInt (@seconds % SECONDS_PER_HOUR) / SECONDS_PER_MINUTE
        secs = parseInt @seconds % SECONDS_PER_MINUTE

        buf = new StringBuilder(24)
        buf.append("PT")
        if hours isnt 0
            buf.append(hours).append('H')
        
        if minutes isnt 0
            buf.append(minutes).append('M')
        
        if secs is 0 and @nanos is 0 and buf.length() > 2
            return buf.toString()
        
        if secs < 0 and @nanos > 0
            if secs is -1
                buf.append("-0")
            else 
                buf.append(secs + 1)
        else
            buf.append(secs)
        
        if @nanos > 0
            pos = buf.length()
            if secs < 0
                buf.append(2 * NANOS_PER_SECOND - @nanos)
            else
                buf.append(@nanos + NANOS_PER_SECOND)
            
            while buf.charAt(buf.length() - 1) is '0'
                buf.setLength(buf.length() - 1)

            buf.setCharAt(pos, '.')
        
        buf.append('S')
        return buf.toString()

module.exports = Duration