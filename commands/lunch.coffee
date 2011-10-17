exports.help = "get lunch menu from <restaurant>, available: ringos"
exports.execute = (place, callback) ->
    if (place == "ringos") 
        jsdom.env("http://www.ringosbistro.se/lunch.php", [
            'http://code.jquery.com/jquery-1.5.min.js'
        ], (err, window) ->
            callback(window.$('html body div div div lksjfalskdjfalskd').text())
        )
