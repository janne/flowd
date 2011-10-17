exports.help = "Get current weather from wunderground"
exports.execute = (args, callback) ->
    jsdom.env "http://api.wunderground.com/auto/wui/geo/WXCurrentObXML/index.xml?query=ESSB", ['http://code.jquery.com/jquery-1.5.min.js'], (err, window) ->
        response = window.$('current_observation weather').text() + ", " + window.$('current_observation temp_c').text() + "°C, relative humidity: " + window.$('current_observation relative_humidity').text()
        callback(response)
