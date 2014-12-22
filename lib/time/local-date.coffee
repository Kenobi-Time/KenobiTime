LocalTime = require './local-time'

class LocalDate

    ###
        The number of days in a 400 year cycle.
    ###
    DAYS_PER_CYCLE = 146097
    
    ###
        The number of days from year zero to year 1970.
        There are five 400 year cycles from year zero to 2000.
        There are 7 leap years from 1970 to 2000.
    ###
    DAYS_0000_TO_1970 = (@DAYS_PER_CYCLE * 5) - (30 * 365 + 7)

    constructor: (@year, @month, @day) ->


module.exports = LocalDate