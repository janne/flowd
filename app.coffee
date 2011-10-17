require.paths.unshift 'commands'
fs = require 'fs'
Flowd = require('./flowd').Flowd

config = {}
try
    config = require('./config').config if (fs.lstatSync 'config.coffee')
config.username = process.env.FLOWD_USERNAME || config.username
config.password = process.env.FLOWD_PASSWORD || config.password
config.flowname = process.env.FLOWD_FLOWNAME || config.flowname
config.messageHost = process.env.FLOWD_MESSAGE_HOST || config.messageHost
new Flowd config
