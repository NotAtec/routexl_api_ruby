# frozen_string_literal: true

require "http"
require 'pry-byebug'

module RouteXL
  class RouteAPI
    def initialize(user = ENV["ROUTEXL_USER"], pass = ENV["ROUTEXL_PASS"])
      @username = user
      @password = pass
    end

    # Status command, returns HTTP status of response.
    def status
      HTTP.basic_auth(user: @username, pass: @password).get('https://api.routexl.com/status').code
    end
  end
end
