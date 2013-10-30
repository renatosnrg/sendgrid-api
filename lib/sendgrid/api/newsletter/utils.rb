require 'sendgrid/api/entities/list'
require 'sendgrid/api/entities/marketing_email'

module Sendgrid
  module API
    module Newsletter
      module Utils

        private

        # Convert the object to an Entities::List.
        def extract_list(object)
          Entities::List.from_object(object)
        end

        # Retrieve the list name.
        def extract_listname(object)
          extract_list(object).list
        end

        # Retrieve the marketing email name
        def extract_marketing_email(marketing_email)
          case marketing_email
          when ::String
            marketing_email
          when Entities::MarketingEmail
            marketing_email.name
          end
        end

      end
    end
  end
end