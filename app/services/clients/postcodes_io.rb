require "faraday"
require "faraday_middleware"

module Clients
  class PostcodesIo
    BASE_URL = "https://api.postcodes.io/postcodes/".freeze
    attr_reader :adapter

    def initialize(adapter: Faraday.default_adapter, stubs: nil)
      @adapter = adapter
      @stubs = stubs
    end

    def retrieve_postcode(postcode)
      response = connection.get(postcode.normalize)
      Result.new(response: response)
    end

    private

    def connection
      @connection ||= Faraday.new do |conn|
        conn.url_prefix = BASE_URL
        conn.request :json # encode req bodies as JSON
        conn.response :json, content_type: "application/json" # decode response bodies as JSON
        conn.adapter adapter, @stubs # allows you to change the adapter esp testing
      end
    end

    class Result
      def initialize(response:)
        @response = response
      end

      def lsoa
        Lsoa.new(@response.body.dig("result", "lsoa"))
      end

      def success?
        @response.status == 200
      end

      def error
        @response.body.dig("error")
      end
    end
  end
end
