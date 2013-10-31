require 'sendgrid/api/service'
require 'sendgrid/api/entities/list'
require 'sendgrid/api/entities/response'
require 'sendgrid/api/newsletter/utils'

module Sendgrid
  module API
    module Newsletter
      module Recipients

        def recipients
          Services.new(resource)
        end

        class Services < Sendgrid::API::Service
          include Newsletter::Utils

          # Assign a List to a Marketing Email.
          #
          # @see http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/recipients.html#-add
          # @param list [String, Entities::List] A list name or Entities::List object.
          # @param marketing_email [String, Entities::MarketingEmail] A marketing email name or Entities::MarketingEmail object.
          # @return [Entities::Response] An Entities::Response object.
          def add(list, marketing_email)
            params = { :list => extract_listname(list), :name => extract_marketing_email(marketing_email) }
            perform_request(Entities::Response, 'newsletter/recipients/add.json', params)
          end

          # Get all lists assigned to a particular Marketing Email.
          #
          # @see http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/recipients.html#-get
          # @param marketing_email [String, Entities::MarketingEmail] A marketing email name or Entities::MarketingEmail object.
          # @return [Array<Entities::List>] An array of Entities::List objects.
          def get(marketing_email)
            params = { :name => extract_marketing_email(marketing_email) }
            perform_request(Entities::List, 'newsletter/recipients/get.json', params)
          end

          # Remove assigned lists from Marketing Email.
          #
          # @see http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/recipients.html#-delete
          # @param list [String, Entities::List] A list name or Entities::List object.
          # @param marketing_email [String, Entities::MarketingEmail] A marketing email name or Entities::MarketingEmail object.
          # @return [Entities::Response] An Entities::Response object.
          def delete(list, marketing_email)
            params = { :list => extract_listname(list), :name => extract_marketing_email(marketing_email) }
            perform_request(Entities::Response, 'newsletter/recipients/delete.json', params)
          end

        end

      end
    end
  end
end