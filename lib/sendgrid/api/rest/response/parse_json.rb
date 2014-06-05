require 'faraday'
require 'json'

module Sendgrid
  module API
    module REST
      module Response
        class ParseJson < Faraday::Response::Middleware

          def parse(body)
            JSON.parse(body, :symbolize_names => true) unless blank?(body)
          end

          private

          def blank?(string)
            string.respond_to?(:empty?) ? !!string.empty? : !string
          end

        end
      end
    end
  end
end
