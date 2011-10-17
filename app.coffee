require.paths.unshift 'commands'
require.paths.unshift('.')
querystring = require 'querystring'
fs = require 'fs'
exec = require('child_process').exec
flowdock = require 'flowdock'

(->
    # Require config
    config = {}

    try
        if (fs.lstatSync 'config.js')
            config = require('./config').config

    config.username = process.env.FLOWD_USERNAME || config.username
    config.password = process.env.FLOWD_PASSWORD || config.password
    config.flowname = process.env.FLOWD_FLOWNAME || config.flowname || 'flowd'
    config.messageHost = process.env.FLOWD_MESSAGE_HOST || config.messageHost
    config.updateInterval = config.updateInterval || 3000
    config.syntaxErrorMessage = config.syntaxErrorMessage || 'Huh?'

    sessionOptions =
        host: 'www.flowdock.com',
        port: 443,
        path: '/session',
        method: 'POST',
        headers:
            Connection: "keep-alive"

    updateInterval = config.updateInterval
    last_sent_at = new Date().getTime()

    availableCommands = {}
    files = fs.readdirSync('commands')
    for i in [0...files.length]
        file = files[i]
        if (file.match(/\.coffee$/))
            command = file.replace(/\.coffee$/, "")
            availableCommands[command] = require(command)

    session = new flowdock.Session(config.username, config.password)
    session.subscribe config.messageHost.split(".")[0], config.flowname
    session.on "message", (message) ->
        parseMessages([message])

    postMessage = (message) ->
        session.chatMessage config.messageHost.split(".")[0], config.flowname, message

    parseMessages = (json, callback) ->
        for i in [0...json.length]
            message = json[i]

            if message.sent > last_sent_at
                last_sent_at = message.sent

            if message.event != 'message'
                return

            match = message.content.match(/^Flowd,?\s(\w*)\s?(.*)/i)

            if match && match.length > 1
                if match[1] == 'help'
                    msg = "    Commands:\n"
                    for own name, cmd of availableCommands
                        if(cmd.help)
                            msg += "    #{name} - #{cmd.help}\n"
                        else
                            msg += "    #{name}\n"
                    postMessage(msg)

                else if availableCommands[match[1]]
                    args = ""
                    if (match.length > 2)
                        args = match[2]
                    availableCommands[match[1]].execute(args, postMessage)
                    continue

                else
                    postMessage config.syntaxErrorMessage
)()
