require.paths.unshift 'commands'
Session = require('flowdock').Session
fs = require 'fs'

class exports.Flowd
    constructor: (@config, SessionClass = Session) ->
        @session = new SessionClass(@config.username, @config.password)
        @session.subscribe @config.messageHost.split(".")[0], @config.flowname
        @session.on "message", (message) => @parseMessages([message])
        @commands = {}
        for file in fs.readdirSync('commands')
            if (file.match(/\.coffee$/))
                command = file.replace(/\.coffee$/, "")
                @commands[command] = require(command)

    postMessage: (message) -> @session.chatMessage @config.messageHost.split(".")[0], @config.flowname, message

    parseMessages: (json, callback) ->
        for message in json
            return if message.event != 'message'
            if match = message.content.match /^(!|bot|flowd[, ])\s*(\w*)\s?(.*)$/i
                [command, args] = match[2..3]
                if command == 'help'
                    msg = "    Commands:\n"
                    msg += "    #{name} - #{cmd.help}\n" for own name, cmd of @commands
                    @postMessage(msg)

                else if @commands[command]
                    @commands[command].execute args, (message) => @postMessage message
                    continue
