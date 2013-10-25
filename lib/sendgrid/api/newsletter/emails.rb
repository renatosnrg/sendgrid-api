require 'sendgrid/api/service'
require 'sendgrid/api/entities/email'
require 'sendgrid/api/entities/response_insert'
require 'sendgrid/api/entities/response_remove'
require 'sendgrid/api/newsletter/utils'

module Sendgrid
  module API
    module Newsletter
      module Emails

        def emails
          Services.new(resource)
        end

        class Services < Sendgrid::API::Service
          include Newsletter::Utils

          # Add one or more emails to a Recipient List.
          #
          # @see http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/emails.html#-add
          # @param list [String, Entities::List] A list name or Entities::List object.
          # @param emails [Array<Entities::Email>] A list of emails to be added. Limited to a 1000 entries maximum.
          # @return [ResponseInsert] An Entities::ResponseInsert object.
          def add(list, emails)
            params = { :list => extract_listname(list), :data => map_emails(emails, :to_json) }
            perform_request(Entities::ResponseInsert, 'newsletter/lists/email/add.json', params)
          end

          # Get the email addresses and associated fields for a Recipient List.
          #
          # @see http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/emails.html#-get
          # @param list [String, Entities::List] A list name or Entities::List object.
          # @param emails [Entities::Email, Array<Entities::Email>] An email or list of emails to be searched and retrieved. Optional.
          # @return [Array<Entities::Email>] An array of Entities::Email object.
          def get(list, emails = nil)
            params = { :list => extract_listname(list) }
            params[:email] = map_emails(emails, :email) if emails
            perform_request(Entities::Email, 'newsletter/lists/email/get.json', params)
          end

          # Remove one or more emails from a Recipient List.
          #
          # @see http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/emails.html#-delete
          # @param list [String, Entities::List] A list name or Entities::List object.
          # @param emails [Entities::Email, Array<Entities::Email>] An email or list of emails to be removed.
          # @return [ResponseRemove] An Entities::ResponseRemove object.
          def delete(list, emails)
            params = { :list => extract_listname(list), :email => map_emails(emails, :email) }
            perform_request(Entities::ResponseRemove, 'newsletter/lists/email/delete.json', params)
          end

          private

          # Return a mapping from an email method name.
          #
          # @param emails [Entities::Email, Array<Entities::Email>] An email or list of emails.
          # @param to [Symbol] The email method name to be mapped.
          # @return [Array] An array of the mapping.
          def map_emails(emails, to)
            emails = [emails] unless emails.is_a?(Array)
            emails.map(&to)
          end

        end
      end
    end
  end
end