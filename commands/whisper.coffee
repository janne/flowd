exports.help = "Say it out, quietly"
exports.execute = (args) ->
    if arg
        exec "say -v whisper #{args}"
