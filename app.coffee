require.paths.unshift 'commands'
require.paths.unshift('.')
querystring = require 'querystring'
fs = require 'fs'
exec = require('child_process').exec
flowdock = require 'flowdock'

class Session
    constructor: (@config) ->
        @session = new flowdock.Session(@config.username, @config.password)
        @session.subscribe @config.messageHost.split(".")[0], @config.flowname
        @session.on "message", (message) => @parseMessages([message])
        @availableCommands = @readCommands()

    readCommands: ->
        commands = {}
        files = fs.readdirSync('commands')
        for i in [0...files.length]
            file = files[i]
            if (file.match(/\.coffee$/))
                command = file.replace(/\.coffee$/, "")
                commands[command] = require(command)
        commands

    postMessage: (message) -> @session.chatMessage @config.messageHost.split(".")[0], @config.flowname, message

    parseMessages: (json, callback) ->
        for i in [0...json.length]
            message = json[i]

            if message.event != 'message'
                return

            match = message.content.match(/^Flowd,?\s(\w*)\s?(.*)/i)

            if match && match.length > 1
                if match[1] == 'help'
                    msg = "    Commands:\n"
                    for own name, cmd of @availableCommands
                        if(cmd.help)
                            msg += "    #{name} - #{cmd.help}\n"
                        else
                            msg += "    #{name}\n"
                    @postMessage(msg)

                else if @availableCommands[match[1]]
                    args = ""
                    if (match.length > 2)
                        args = match[2]
                    @availableCommands[match[1]].execute args, (message) =>
                        @postMessage message
                    continue

                else
                    @postMessage "Huh?"

config = {}
try
    if (fs.lstatSync 'config.coffee')
        config = require('./config').config
config.username = process.env.FLOWD_USERNAME || config.username
config.password = process.env.FLOWD_PASSWORD || config.password
config.flowname = process.env.FLOWD_FLOWNAME || config.flowname
config.messageHost = process.env.FLOWD_MESSAGE_HOST || config.messageHost
new Session config
