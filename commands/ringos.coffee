jsdom = require 'jsdom'
exports.help = "get lunch menu of the week from Ringos"
exports.execute = (args, callback) ->
    jsdom.env "http://www.ringosbistro.se/lunch.php", ['http://code.jquery.com/jquery-1.5.min.js'], (err, window) ->
        text = window.$('html body div div div lksjfalskdjfalskd').text()
        text = "    " + text.split("\r\n").join("\n")
        callback text
