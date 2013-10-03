require 'faraday'
require 'json'

module Sendgrid
  module API
    module REST
      module Response
        class ParseJson < Faraday::Response::Middleware

          def parse(body)
            JSON.parse(body, :symbolize_names => true)
          end

        end
      end
    end
  end
end
