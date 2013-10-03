require 'sendgrid/api/entities/entity'

module Sendgrid
  module API
    module Entities
      class Profile < Entity

        attribute :username, :email, :active, :first_name, :last_name, :address,
                  :address2, :city, :state, :zip, :country, :phone, :website, :website_access

      end
    end
  end
end