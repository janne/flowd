jsdom = require 'jsdom'
exports.help = "Get current weather from wunderground"
exports.execute = (args, callback) ->
    jsdom.env "http://api.wunderground.com/auto/wui/geo/WXCurrentObXML/index.xml?query=ESSB", ['http://code.jquery.com/jquery-1.5.min.js'], (err, window) ->
        observation = window.$('current_observation weather').text()
        temp = window.$('current_observation temp_c').text()
        humidity = window.$('current_observation relative_humidity').text()
        callback "The current weather in Stockholm is #{observation}, #{temp}°C, relative humidity: #{humidity}. Have a nice day!"
