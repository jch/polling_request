# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = "polling_request"
  s.version     = "0.0.2"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jerry Cheung"]
  s.email       = ["jch@whatcodecraves.com"]
  s.homepage    = "https://github.com/jch/polling_request"
  s.summary     = "Railtie for progress aware AJAX polling"
  s.description = "This gem adds polling_request Javascript assets to Rail's asset pipeline"
  s.files       = %w(lib/polling_request.rb src/polling_request.coffee src/polling_request.js README.md)

  s.add_dependency "railties", ">= 3.0"
end
