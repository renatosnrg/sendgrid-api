require 'sendgrid/api/service'
require 'sendgrid/api/entities/list'
require 'sendgrid/api/entities/response'
require 'sendgrid/api/newsletter/utils'

module Sendgrid
  module API
    module Newsletter
      module Lists

        def lists
          Services.new(resource)
        end

        class Services < Sendgrid::API::Service
          include Newsletter::Utils

          # Create a new Recipient List.
          #
          # @see http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/lists.html#-add
          # @param list [String, Entities::List] A new list name or Entities::List object.
          # @return [Response] An Entities::Response object.
          def add(list)
            params = { :list => extract_listname(list) }
            perform_request(Entities::Response, 'newsletter/lists/add.json', params)
          end

          # Rename a Recipient List.
          #
          # @see http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/lists.html#-edit
          # @param list [String, Entities::List] An existing list name or Entities::List object.
          # @param newlist [String, Entities::List] A new list name or Entities::List object.
          # @return [Response] An Entities::Response object.
          def edit(list, newlist)
            params = { :list => extract_listname(list), :newlist => extract_listname(newlist) }
            perform_request(Entities::Response, 'newsletter/lists/edit.json', params)
          end

          # List all Recipient Lists on your account, or check if a particular List exists.
          #
          # @see http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/lists.html#-get
          # @param list [String, Entities::List] An existing list name or Entities::List object. Optional.
          # @return [List] An array of Entities::List objects.
          def get(list = nil)
            params = { :list => extract_listname(list) } if list
            perform_request(Entities::List, 'newsletter/lists/get.json', params || {})
          end

          # Remove a Recipient List from your account.
          #
          # @see http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/lists.html#-delete
          # @param list [String, Entities::List] An existing list name or Entities::List object.
          # @return [Response] An Entities::Response object.
          def delete(list)
            params = { :list => extract_listname(list) }
            perform_request(Entities::Response, 'newsletter/lists/delete.json', params)
          end

        end

      end
    end
  end
end