# Polling Request [![Build Status](https://secure.travis-ci.org/jch/polling_request.png)](http://travis-ci.org/jch/polling_request)

jQuery helper object for AJAX polling a [progress-aware endpoint](#progress-aware-endpoint).

## Usage

```coffeescript
req = PollingRequest.new
  url: "/states.csv"
  interval: 1000   # polling interval in milliseconds
  progress: (n)->
    console.log "Progress: #{n} percent"
  success: (res)->
    console.log "Response body: #{res}"
  error: (status, response)->
    console.log("Status: #{status}, Body: #{response}")

req.status   # 'pending'
req.start()
req.status   # 'running'
req.progress # 0

# sometime later
req.status   # 'running'
req.progress # 50

# much later
req.status   # 'success'
req.progress # 100

# example of setting a hard timeout
setTimeout ->
  req.stop()
, 5000
```

## Progress Aware Endpoint

PollingRequests will have a header `X-POLLING-REQUEST` set. It expects an HTTP
endpoint to respond with a [202 Accepted][202] status code when there is more
processing to be done. The JSON encoded response body must include a 'requestId'
property for tracking this request. It's value must be unique across requests.
The body can optionally include a `progress` property whose value is an integer
0..100 inclusive to indicate the percentage of processing completed.

```bash
$ curl -i -H'X-POLLING-REQUEST:' http://localhost/endpoint
HTTP/1.1 202 Accepted
{ requestId: 'custom-request-uuid', progress: 0 }

# subsequent requests will include the requestId
$ curl -i -H'X-POLLING-REQUEST: custom-request-uuid' http://localhost/endpoint
HTTP/1.1 202 Accepted
{ requestId: 'custom-request-uuid', progress: 0 }

$ curl -i -H'X-POLLING-REQUEST: custom-request-uuid' http://localhost/endpoint
HTTP/1.1 200 Success
Content-Type: text/plain
Successful responses can be any content type
```

[202]: http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html#sec10.2.3

## Development

Tests are written with QUnit and can be run in a browser by opening
`test/test.html`. Continuous integration is run with phantomjs:

```bash
$ phantomjs test/runner.js test/test.html
```

## Wish List

* RailTie for easy Rails installation
* Better docs for building and installing project
* Bower compatibility

## Contributing

1. [Fork it](https://help.github.com/articles/fork-a-repo)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](https://help.github.com/articles/using-pull-requests)
