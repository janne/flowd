exports.help = "Say it out loud!"
exports.execute = (arg) ->
    if (arg)
        exec('say '+arg)
