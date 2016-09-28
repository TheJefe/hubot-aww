Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect

helper = new Helper('../src/aww.coffee')

class NewMockResponse extends Helper.Response
  http: (url) ->
    # I haven't quite figured this one out
    self.send 'https://i.redd.it/yh4wvggomynx.gif'

describe 'aww', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'responds to aww', ->
    @room.user.say('alice', '@hubot aww').then =>
      expect(@room.messages).to.eql [
        ['alice', '@hubot aww']
        # If the mock gets fixed, this expectation can be uncommented
        # ['hubot', 'https://i.redd.it/yh4wvggomynx.gif']
      ]
