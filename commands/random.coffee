exports.help = "get random number from 0 to <max>"
exports.execute = (args, callback) ->
    if args == ""
        callback "Please provide a max random number"
    else if isNaN(args)
        callback "That's not a number!"
    else
        callback "" + Math.floor(Math.random()*args)
