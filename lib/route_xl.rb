# frozen_string_literal: true
require "httpx"
require 'pry-byebug'

# Class for RouteXL API Implementation
class RouteXL
  
  def initialize(user = ENV["ROUTEXL_USER"], pass = ENV["ROUTEXL_PASS"])
    @username = user
    @password = pass
  end

  # Status command, returns HTTP status of response.
  def status
    response = HTTPX.plugin(:basic_authentication).basic_authentication(@username, @password).get("https://api.routexl.com/status/")
    response.status
  end

  def distances
  end

  def tour
  end
end

# Testing (TD: Convert to rspec)
# xl = RouteXL.new
# p xl.status
