require 'faraday'
require 'sendgrid/api/rest/response/parse_json'
require 'sendgrid/api/rest/response/parse_error'

module Sendgrid
  module API
    module REST
      class Resource

        attr_reader :user, :key

        ENDPOINT = 'https://api.sendgrid.com/api'.freeze

        def initialize(user, key)
          @user = user
          @key = key
        end

        def post(url, params = {})
          request(:post, url, params)
        end

        private

        def request(method, url, params = {})
          params = params.merge(authentication_params)
          connection.send(method, url, params)
        rescue Faraday::Error::ClientError, JSON::ParserError
          raise Errors::Unknown
        end

        def middleware
          @middleware ||= Faraday::RackBuilder.new do |builder|
            # checks for files in the payload, otherwise leaves everything untouched
            builder.request :multipart
            # form-encode POST params
            builder.request :url_encoded
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