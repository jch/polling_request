# Options:
#
#  url: progress aware HTTP endpoint. See README.md
#  interval: to poll in milliseconds
#  success: callback for response body
#  progress: callback for integer percentage
#  error: callback with status code and response body
#  stopped: callback after request stops
class PollingRequest
  constructor: (@options) ->
    @progress = 0
    @status   = 'pending'
    @options.interval or= 1000
    @options.success  or= ->
    @options.progress or= ->
    @options.error    or= ->
    @options.stopped  or= ->

  # Public: schedule polling by `options.interval`
  start: ->
    return if @timer
    @timer = setInterval =>
      @_run()
    , @options.interval

  # Public: stop polling. Status becomes 'stopped'
  stop: ->
    @status = 'stopped'
    clearInterval(@timer)
    @timer = null
    @options.stopped()

  # Public: one of 'pending', 'running', 'stopped'
  status: ->
    @status

  # Public: integer 0..100 inclusive indicating percentage complete
  progress: ->
    @progress

  # Private: runs the actual ajax request
  _run: ->
    $.ajax
      url: @options.url
      cached: false  # what does 304 not modified mean in this context?
      accepts:
        json: 'application/json'
      beforeSend: (jqXHR, settings) =>
        @status = 'running'
      statusCode:
        # The request has succeeded.
        200: (data, textStatus, jqXHR) =>
          @progress = 100
          @options.success(data)
          @stop()

        # The request has been accepted for processing, but the processing has
        # not been completed.
        202: (data, textStatus, jqXHR) =>
          @progress = data.progress or 0
          @options.progress(@progress)
      error: (jqXHR, textStatus, errorThrown) =>
        @options.error(jqXHR.status, jqXHR.responseText)
        @stop()

(exports ? this).PollingRequest = PollingRequest