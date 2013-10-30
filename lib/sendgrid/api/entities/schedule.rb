require 'sendgrid/api/entities/entity'

module Sendgrid
  module API
    module Entities
      class Schedule < Entity

        attribute :date

      end
    end
  end
end