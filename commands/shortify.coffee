http = require('http')
exports.help = "Shortify provided <url>"
exports.execute = (url, callback) ->
    if url?
        http.get host: 'is.gd', path: "/create.php?format=simple&url=#{url}", (res) ->
            data = ''
            res.on 'data', (chunk) ->
                data += chunk.toString()
            res.on 'end', ->
                callback(data)
    else
        callback('Please supply a URL!')
