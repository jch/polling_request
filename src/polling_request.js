// Generated by CoffeeScript 1.6.3
(function() {
  var PollingRequest;

  PollingRequest = (function() {
    function PollingRequest(options) {
      var _base, _base1, _base2, _base3, _base4;
      this.options = options;
      this.progress = 0;
      this.status = 'pending';
      (_base = this.options).interval || (_base.interval = 1000);
      (_base1 = this.options).success || (_base1.success = function() {});
      (_base2 = this.options).progress || (_base2.progress = function() {});
      (_base3 = this.options).error || (_base3.error = function() {});
      (_base4 = this.options).stopped || (_base4.stopped = function() {});
    }

    PollingRequest.prototype.start = function() {
      var _this = this;
      if (this.timer) {
        return;
      }
      return this.timer = setInterval(function() {
        return _this._run();
      }, this.options.interval);
    };

    PollingRequest.prototype.stop = function() {
      this.status = 'stopped';
      clearInterval(this.timer);
      this.timer = null;
      return this.options.stopped();
    };

    PollingRequest.prototype.status = function() {
      return this.status;
    };

    PollingRequest.prototype.progress = function() {
      return this.progress;
    };

    PollingRequest.prototype._run = function() {
      var _this = this;
      return $.ajax({
        url: this.options.url,
        cached: false,
        accepts: {
          json: 'application/json'
        },
        beforeSend: function(jqXHR, settings) {
          return _this.status = 'running';
        },
        statusCode: {
          200: function(data, textStatus, jqXHR) {
            _this.progress = 100;
            _this.options.success(data);
            return _this.stop();
          },
          202: function(data, textStatus, jqXHR) {
            _this.progress = data.progress || 0;
            return _this.options.progress(_this.progress);
          }
        },
        error: function(jqXHR, textStatus, errorThrown) {
          _this.options.error(jqXHR.status, jqXHR.responseText);
          return _this.stop();
        }
      });
    };

    return PollingRequest;

  })();

  (typeof exports !== "undefined" && exports !== null ? exports : this).PollingRequest = PollingRequest;

}).call(this);
