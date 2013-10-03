require 'faraday'
require 'sendgrid/api/rest/response/parse_json'
require 'sendgrid/api/rest/response/parse_error'

module Sendgrid
  module API
    module REST
      class Resource

        attr_reader :user, :key

        ENDPOINT = 'https://sendgrid.com/api'

        def initialize(user, key)
          @user = user
          @key = key
        end

        def get(url, params = {})
          connection.get do |req|
            req.url url
            req.params = params.merge(authentication_params)
            req.headers['Content-Type'] = 'application/json'
          end
        end

        private

        def middleware
          @middleware ||= Faraday::Builder.new do |builder|
            # Parse response errors
            builder.use Response::ParseError
            # Parse JSON response bodies
            builder.use Response::ParseJson
            # Set Faraday's HTTP adapter
            builder.adapter Faraday.default_adapter
          end
        end

        def connection
          @connection ||= Faraday.new(ENDPOINT, :builder => middleware)
        end

        def authentication_params
          { :api_user => @user, :api_key => @key }
        end

      end
    end
  end
end