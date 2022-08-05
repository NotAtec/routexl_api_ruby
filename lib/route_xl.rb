# frozen_string_literal: true

require "http"
require 'pry-byebug'
require 'json'

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

    def distances(locations_arr)
      body = location_setup(locations_arr)
      basic_request(locations_arr, body, 'distances')
    end

    def tour(locations_arr)
      body = location_setup(locations_arr)
      basic_request(locations_arr, body, 'tour')
    end

    private

    def location_setup(locations_arr)
      location_check(locations_arr)
      "locations=#{locations_arr.to_json}"
    end

    def basic_request(locations_arr, body, req)
      response = HTTP.basic_auth(user: @username, pass: @password).post("https://api.routexl.com/#{req}", body: body)
      response_check(response.code)
      response.parse
    end

    def location_check(array)
      raise ClassError.new("Not all objects in array are instance of Location") unless array.all? { |element| element.instance_of? Location }
    end

    def response_check(code)
      case code
      when 401
        raise AuthError
      when 403
        raise SubscriptionError
      when 409
        raise NoInputError
      when 429
        raise InProgressError
      when 204
        raise NotFoundError
      else
      end
    end
  end

  class Location
    def initialize(address, lat, lng, servicetime = 5, *restrictions)
      @address = address
      @latitude = lat
      @longitude = lng
      @st = servicetime
      setup(restrictions)
    end
  
    def as_json(options={})
      {
        address: @address,
        lat: @latitude,
        lng: @longitude,
        servicetime: @st,
        ready: @ready,
        due: @due,
        before: @before,
        after: @after
      }
    end
  
    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  
    private
  
    def setup(restrictions)
      case restrictions.length
      when 0
      when 1
        @ready = restrictions[0]
      when 2
        @ready = restrictions[0]
        @due = restrictions[1]
      when 3
        @ready = restrictions[0]
        @due = restrictions[1]
      when 4
        @ready = restrictions[0]
        @due = restrictions[1]
        @before = restrictions[2] if restrictions[3] == 'before'
        @after = restrictions[2] if restrictions[3] == 'after'
      else
        raise RestrictionAmountError
      end
    end
  end

  class ClassError < StandardError
    def initialize(msg="Not all objects in array are of correct class")
      super
    end
  end

  class AuthError < StandardError
    def initialize(msg="There has been an authentication problem, check your credentials")
      super
    end
  end

  class SubscriptionError < StandardError
    def initialize(msg="Too many locations were input for the existing subscription.")
      super
    end
  end

  class NoInputError < StandardError
    def initialize(msg="No input was found")
      super
    end
  end

  class InProgressError < StandardError
    def initialize(msg="Another route is in progress, try again")
      super
    end
  end

  class NotFoundError < StandardError
  end

  class RestrictionAmountError < StandardError
    def initialize(msg="Too many restrictions entered")
      super
    end
  end
end
