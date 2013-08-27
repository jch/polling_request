require 'rails/railtie'

module PollingRequest
  class Railtie < ::Rails::Railtie
    config.to_prepare do
      Rails.application.config.assets.paths << File.expand_path('../../src', __FILE__)
    end
  end
end
