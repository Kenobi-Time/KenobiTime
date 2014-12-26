# this has the same value Number.MAX_SAFE_INTEGER
# see https://developer.mozilla.org/de/docs/Web/JavaScript/Reference/Global_Objects/Number/MAX_SAFE_INTEGER
MAX_SAFE_INTEGER = Math.pow(2, 53) - 1
MIN_SAFE_INTEGER = -MAX_SAFE_INTEGER

int = (real) ->
    return real - (real % 1)

compare = (x, y) ->
    if x < y
        return -1
    else if x > y
        return 1
    else
        return 0

checkSafeInt = (value) ->
    if value > MAX_SAFE_INTEGER
        throw new Error 'arithmetic overflow'
    else if value < MIN_SAFE_INTEGER
        throw new Error 'arithmetic underflow'

addExact = (x, y) ->
    r = int x + y
    checkSafeInt r
    return r

floorDiv = (x, y) ->
    r = int x / y
    #if the signs are different and modulo not zero, round down
    # TODO: test this condition
    if (x ^ y) < 0 and (r * y isnt x)
        r--
    return r

floorMod = (x, y) ->
    return x - floorDiv(x, y) * y

multiplyExact = (x, y) ->
        r = int x * y
        checkSafeInt r
        return r

module.exports = {
    MAX_SAFE_INTEGER
    MIN_SAFE_INTEGER
    int
    addExact
    floorDiv
    floorMod
    multiplyExact
}