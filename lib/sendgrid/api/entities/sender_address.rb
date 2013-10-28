require 'sendgrid/api/entities/entity'

module Sendgrid
  module API
    module Entities
      class SenderAddress < Entity

        attribute :identity, :name, :email, :replyto, :address, :city, :state, :zip, :country

      end
    end
  end
end