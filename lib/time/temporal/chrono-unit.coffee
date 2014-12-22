Duration = require '../duration'

DAY = 60 * 60 * 24
YEAR = 365.2425 * DAY

# this has the same value Number.MAX_SAFE_INTEGER
# see https://developer.mozilla.org/de/docs/Web/JavaScript/Reference/Global_Objects/Number/MAX_SAFE_INTEGER
MAX_VALUE = Math.pow(2, 53) - 1

class ChronoUnit

    @NANOS = Duration.ofNanos(1)
    @MICROS = Duration.ofNanos(1000)
    @MILLIS = Duration.ofNanos(1000000)
    @SECONDS = Duration.ofSeconds(1)
    @MINUTES = Duration.ofSeconds(60)
    @HOURS = Duration.ofSeconds(3600)
    @HALF_DAYS = Duration.ofSeconds(43200)
    @DAYS = Duration.ofSeconds(86400)
    @WEEKS = Duration.ofSeconds(7 * DAY)
    @MONTHS = Duration.ofSeconds(YEAR / 12)
    @YEARS = Duration.ofSeconds(YEAR)
    @DECADES = Duration.ofSeconds(YEAR * 10)
    @CENTURIES = Duration.ofSeconds(YEAR * 100)
    @MILLENNIA = Duration.ofSeconds(YEAR * 1000)
    @ERAS = Duration.ofSeconds(YEAR * 1000000000)
    @FOREVER = Duration.ofSeconds(MAX_VALUE, 999999999))

module.exports = ChronoUnit