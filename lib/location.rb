# frozen_string_literal: true

require 'pry-byebug'
require 'json'
# Example class for location object used with API
class Location
  
  def initialize(address, lat, lng)
    @address = address
    @latitude = lat
    @longitude = lng
  end

  def as_json(options={})
    {
      address: @address,
      lat: @latitude,
      lng: @longitude
    }
  end

  def to_json(*options)
    as_json(*options).to_json(*options)
  end
end