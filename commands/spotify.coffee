exports.help = "Skip to <previous> or <next> song in spotify"
exports.execute = (arg) ->
    if (arg == "next")
        exec("osascript -e 'tell application \"Spotify\" to next track'")
    else if (arg == "previous")
        exec("osascript -e 'tell application \"Spotify\" to previous track'")
