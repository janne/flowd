flowdock = require('flowdock')
fs = require 'fs'

class global.Flowd
    constructor: (@config) ->
        @session = new flowdock.Session(@config.username, @config.password)
        @session.subscribe @config.messageHost.split(".")[0], @config.flowname
        @session.on "message", (message) => @parseMessages([message])
        @availableCommands = @readCommands()

    readCommands: ->
        commands = {}
        for file in fs.readdirSync('commands')
            if (file.match(/\.coffee$/))
                command = file.replace(/\.coffee$/, "")
                commands[command] = require(command)
        commands

    postMessage: (message) -> @session.chatMessage @config.messageHost.split(".")[0], @config.flowname, message

    parseMessages: (json, callback) ->
        for message in json
            return if message.event != 'message'
            if match = message.content.match /^(!|bot[, ])\s*(\w*)\s?(.*)$/i
                [command, args] = match[2..3]
                if command == 'help'
                    msg = "    Commands:\n"
                    msg += "    #{name} - #{cmd.help}\n" for own name, cmd of @availableCommands
                    @postMessage(msg)

                else if @availableCommands[command]
                    @availableCommands[command].execute args, (message) => @postMessage message
                    continue
