class StringBuilder

    constructor: (param) ->
        @buffer = ''
        @size = 0
        if (typeof param) is 'number'
            # reserve size
        else if (typeof param) is 'string'
            @buffer = param
            @size = param.length

    append: (chunk) ->
        @buffer += chunk
        @size += (''+chunk).length
        return this

    toString: ->
        return @buffer

    length: ->
        return @size

    charAt: (position) ->
        return @buffer[position]

    setCharAt: (position, char) ->
        if position < 0 or position >= @size
            throw new Error "cannot content at position #{position} with a size of #{@size}"
        str = @buffer.split ''
        str[position] = char
        @buffer = str.join ''
        return

    setLength: (length) ->
        @buffer = @buffer.substr 0, length
        @size = @buffer.length
        return

module.exports = StringBuilder