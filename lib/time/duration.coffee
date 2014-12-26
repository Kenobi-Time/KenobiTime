MathUtils = require '../utils/math-utils'
int = MathUtils.int
StringBuilder = require '../utils/string-builder'

LocalTime = require './local-time'

SECONDS_PER_HOUR = LocalTime.SECONDS_PER_HOUR
SECONDS_PER_MINUTE = LocalTime.SECONDS_PER_MINUTE
NANOS_PER_SECOND = LocalTime.NANOS_PER_SECOND

class Duration

    @ZERO = new Duration(0, 0)

    @create = (seconds, nanoAdjustment) ->
        if (seconds | nanoAdjustment) is 0
            return @ZERO

        return new Duration(seconds, nanoAdjustment)

    @ofSeconds = (seconds, nanoAdjustment) ->
        unless nanoAdjustment?
            return @create(seconds, 0)

        secs = MathUtils.addExact(seconds, MathUtils.floorDiv(nanoAdjustment, NANOS_PER_SECOND))
        nos = int MathUtils.floorMod(nanoAdjustment, NANOS_PER_SECOND)
        return @create(secs, nos)

    @ofNanos = (nanos) ->
        secs = int nanos / NANOS_PER_SECOND
        nos = int nanos % NANOS_PER_SECOND
        if nos < 0
            nos += NANOS_PER_SECOND
            secs--
        return @create(secs, nos)

    constructor: (@seconds, @nanos) ->

    isZero: ->
        return (@seconds | @nanos) is 0

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