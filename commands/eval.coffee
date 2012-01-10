exports.help = "Evalute it!"
exports.execute = (args, callback) ->
    callback eval(args)

