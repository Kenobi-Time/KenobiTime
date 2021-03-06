class LocalTime

    @HOURS = []
    for hour in [0..23]
        @HOURS[hour] = new LocalTime(hour, 0, 0, 0)

    @MIDNIGHT = @HOURS[0]
    @NOON = @HOURS[12]
    @MIN = @HOURS[0]
    @MAX = new LocalTime(23, 59, 59, 999999999)
    @HOURS_PER_DAY = 24
    @MINUTES_PER_HOUR = 60
    @MINUTES_PER_DAY = @MINUTES_PER_HOUR * @HOURS_PER_DAY
    @SECONDS_PER_MINUTE = 60
    @SECONDS_PER_HOUR = @SECONDS_PER_MINUTE * @MINUTES_PER_HOUR
    @SECONDS_PER_DAY = @SECONDS_PER_HOUR * @HOURS_PER_DAY
    @MILLIS_PER_DAY = @SECONDS_PER_DAY * 1000
    @MICROS_PER_DAY = @SECONDS_PER_DAY * 1000000
    @NANOS_PER_SECOND = 1000000000
    @NANOS_PER_MINUTE = @NANOS_PER_SECOND * @SECONDS_PER_MINUTE
    @NANOS_PER_HOUR = @NANOS_PER_MINUTE * @MINUTES_PER_HOUR
    @NANOS_PER_DAY = @NANOS_PER_HOUR * @HOURS_PER_DAY

    constructor: (@hour, @min, @second, @nano) ->

module.exports = LocalTime