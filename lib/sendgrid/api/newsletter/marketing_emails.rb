require 'sendgrid/api/service'
require 'sendgrid/api/entities/marketing_email'
require 'sendgrid/api/entities/response'
require 'sendgrid/api/newsletter/utils'

module Sendgrid
  module API
    module Newsletter
      module MarketingEmails

        def marketing_emails
          Services.new(resource)
        end

        class Services < Sendgrid::API::Service
          include Newsletter::Utils

          # Create a new Marketing Email.
          #
          # @see http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/newsletters.html#-add
          # @param marketing_email [Entities::MarketingEmail] An Entities::MarketingEmail object.
          # @return [Response] An Entities::Response object.
          def add(marketing_email)
            perform_request(Entities::Response, 'newsletter/add.json', marketing_email.as_json)
          end

          # Edit an existing Marketing Email.
          #
          # @see http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/newsletters.html#-edit
          # @param marketing_email [Entities::MarketingEmail] An Entities::MarketingEmail object.
          # @param newname [String] The new name for the Marketing Email being edited. Optional.
          # @return [Response] An Entities::Response object.
          def edit(marketing_email, newname = nil)
            params = marketing_email.as_json
            params.merge!(:newname => newname) if newname
            perform_request(Entities::Response, 'newsletter/edit.json', params)
          end

          # Retrieve the contents of an existing Marketing Email.
          #
          # @see http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/newsletters.html#-get
          # @param marketing_email [String, Entities::MarketingEmail] An existing marketing email name or Entities::MarketingEmail object.
          # @return [MarketingEmail] An Entities::MarketingEmail object.
          def get(marketing_email)
            params = { :name => extract_marketing_email(marketing_email) }
            perform_request(Entities::MarketingEmail, 'newsletter/get.json', params)
          end

          # Retrieve a list of all existing Marketing Email.
          #
          # @see http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/newsletters.html#-list
          # @return [Array<MarketingEmail>] An array of Entities::MarketingEmail objects.
          def list
            perform_request(Entities::MarketingEmail, 'newsletter/list.json')
          end

          # Remove an existing Marketing Email.
          #
          # @see http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/newsletters.html#-delete
          # @param marketing_email [String, Entities::MarketingEmail] An existing marketing email name or Entities::MarketingEmail object.
          # @return [Response] An Entities::Response object.
          def delete(marketing_email)
            params = { :name => extract_marketing_email(marketing_email) }
            perform_request(Entities::Response, 'newsletter/delete.json', params)
          end

        end

      end
    end
  end
end