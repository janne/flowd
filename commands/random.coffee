exports.help = "get random number from 0 to <max>"
exports.execute = (args, callback) ->
    if args == ""
        callback "Please provide a max random number"
    if isNaN(args)
        items = args.split(" ")
        callback items[Math.floor(Math.random()*items.length)]
    else
        callback "" + Math.floor(Math.random()*args)
