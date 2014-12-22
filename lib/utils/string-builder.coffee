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
        @size += chunk.length
        return this

    toString: ->
        return @buffer

    length: ->
        return @size

    charAt: (position) ->
        @buffer[position]

    setCharAt: (position, char) ->
        @buffer[position] = char
        return

    setLength: (length) ->
        @buffer.substr 0, length
        return

module.exports = StringBuilder