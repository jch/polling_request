test "status", ->
  req = new PollingRequest(url: "/poll")
  ok req.status   == 'pending', 'initial status is pending'
  ok req.progress == 0, 'initial progress'
  ok req.options.interval == 1000, 'defaults interval'

test "start", ->
  clock = sinon.useFakeTimers()
  req = new PollingRequest(url: "/poll")
  req.start()
  clock.tick(2000)
  ok req.status == 'running', "expected 'running', got #{req.status}"
  clock.restore()

test "success", ->
  clock = sinon.useFakeTimers()
  server = sinon.fakeServer.create()
  server.autoRespond = true
  server.respondWith (request)->
    request.respond(200, {'Content-Type': 'text/plain'}, "response body")

  callback = sinon.spy()
  req = new PollingRequest
    url: "/poll"
    success: callback

  req.start()
  clock.tick(2500) # make sure no future calls are made

  ok req.status == 'stopped', "expected 'stopped', got #{req.status}"
  ok callback.callCount == 1, "expected one call, called #{callback.callCount} times"
  ok callback.calledWith("response body"), "expected success callback"
  clock.restore()

test "progress", ->
  clock = sinon.useFakeTimers()
  server = sinon.fakeServer.create()
  server.autoRespond = true
  server.respondWith (request)->
    request.respond(202, {'Content-Type': 'application/json'}, JSON.stringify(progress: 10))

  callback = sinon.spy()
  req = new PollingRequest
    url: "/poll"
    progress: callback

  req.start()
  clock.tick(3500)

  ok req.status == 'running'
  ok req.progress == 10, "expected 10 progress, got #{req.progress}"
  ok callback.callCount == 3, "expected 3 calls, called #{callback.callCount} times"
  ok callback.alwaysCalledWith(10), "expected success callback"
  clock.restore()

test "error", ->
  clock = sinon.useFakeTimers()
  server = sinon.fakeServer.create()
  server.autoRespond = true
  server.respondWith (request)->
    request.respond(404, {'Content-Type': 'text/html'}, "<h1>Not Found</h1>")

  callback = sinon.spy()
  req = new PollingRequest
    url: "/poll"
    error: callback

  req.start()
  clock.tick(2500)

  ok req.status == 'stopped'
  ok callback.callCount == 1, "expected 1 call, called #{callback.callCount} times"
  ok callback.calledWith(404, "<h1>Not Found</h1>"), "expected success callback"
  clock.restore()

test "stopped", ->
  callback = sinon.spy()
  req = new PollingRequest
    url: "/poll",
    stopped: callback

  req.stop()
  ok callback.calledOnce, "expected 1 call"