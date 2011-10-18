Flowd = require('../flowd').Flowd
Session = require('flowdock').Session

config =
    username: "user@name.com",
    password: "password",
    flowname: "main",
    messageHost: 'flow.flowdock.com'

describe "Flowd", ->
    beforeEach ->
        spyOn(Session.prototype, 'login')
        this.addMatchers toInclude: (expected) -> this.actual.indexOf(expected) >= 0

    it 'should be able to create an instance', ->
        flowd = new Flowd config, Session
        expect(typeof flowd).toEqual('object')
        expect(Session.prototype.login).toHaveBeenCalled()

    it 'should have some commands', ->
        flowd = new Flowd config, Session
        expect(key for own key of flowd.commands).toInclude 'ping'
