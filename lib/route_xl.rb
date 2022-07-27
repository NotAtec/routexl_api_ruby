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

    def distances(array, maxDistance*)
      location_check(array)
      body = maxDistance = [] ? "locations=#{array.to_json}": "locations=#{array.to_json}&maxDistance=#{maxDistance[0]}"

      response = HTTP.basic_auth(user: @username, pass: @password).post('https://api.routexl.com/distancs', body: body)
      response_check(response.code)

      response.parse
    end

    private

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
end
