require 'sendgrid/api/entities/entity'

module Sendgrid
  module API
    module Entities
      class Response < Entity

        attribute :message, :errors

        def success?
          message == 'success'
        end

        def error?
          message == 'error'
        end

      end
    end
  end
end