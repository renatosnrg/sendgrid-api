require 'faraday'
require 'sendgrid/api/rest/errors/error'

module Sendgrid
  module API
    module REST
      module Response
        class ParseError < Faraday::Response::Middleware

          def on_complete(env)
            error = REST::Errors::Error.from_response(env)
            raise error unless error.nil?
          end

        end
      end
    end
  end
end
