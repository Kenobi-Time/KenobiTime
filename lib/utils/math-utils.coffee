addExact = (x, y) ->
    r = Math.floor  x + y
    # HD 2-12 Overflow iff both arguments have the opposite sign of the result
    if (((x ^ r) & (y ^ r)) < 0) 
        throw new Error 'long overflow'
    
    return r

floorDiv = (x, y) ->
    r = Math.floor x / y;
    #if the signs are different and modulo not zero, round down
    if (x ^ y) < 0 && (r * y != x)
        r--
    return r

floorMod = (x, y) ->
    return x - floorDiv(x, y) * y

multiplyExact = (x, y) ->
        r = Math.floor x * y
        ax = Math.floor Math.abs(x)
        ay = Math.floor Math.abs(y)
        if (((ax | ay) >>> 31 != 0)) 
            # Some bits greater than 2^31 that might cause overflow
            # Check the result using the divide operator
            # and check for the special case of Long.MIN_VALUE * -1
           if (((y != 0) && (r / y != x)) || (x == Long.MIN_VALUE && y == -1))
                throw new Error 'long overflow'
        return r

module.exports = {
    addExact
    floorDiv
    floorMod
    multiplyExact
}