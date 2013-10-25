require 'sendgrid/api/entities/entity'

module Sendgrid
  module API
    module Entities
      class Email < Entity

        attribute :email, :name

      end
    end
  end
end