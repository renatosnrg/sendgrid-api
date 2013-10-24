require 'sendgrid/api/service'
require 'sendgrid/api/entities/list'
require 'sendgrid/api/entities/response'

module Sendgrid
  module API
    module Newsletter
      module Lists

        def lists
          Services.new(resource)
        end

        class Services < Sendgrid::API::Service

          # Create a new Recipient List.
          #
          # @see http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/lists.html#-add
          # @param list [String, Entities::List] A new list name or Entities::List object.
          # @return response [Response] An Entities::Response object.
          def add(list)
            params = { :list => extract_name(list) }
            perform_request(Entities::Response, 'newsletter/lists/add.json', params)
          end

          # Rename a Recipient List.
          #
          # @see http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/lists.html#-edit
          # @param list [String, Entities::List] An existing list name or Entities::List object.
          # @param newlist [String, Entities::List] A new list name or Entities::List object.
          # @return response [Response] An Entities::Response object.
          def edit(list, newlist)
            params = { :list => extract_name(list), :newlist => extract_name(newlist) }
            perform_request(Entities::Response, 'newsletter/lists/edit.json', params)
          end

          # List all Recipient Lists on your account, or check if a particular List exists.
          #
          # @see http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/lists.html#-get
          # @param list [String, Entities::List] An existing list name or Entities::List object. Optional.
          # @return list [List] An array of Entities::List objects.
          def get(list = nil)
            params = { :list => extract_name(list) } if list
            perform_request(Entities::List, 'newsletter/lists/get.json', params || {})
          end

          # Remove a Recipient List from your account.
          #
          # @see http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/lists.html#-delete
          # @param list [String, Entities::List] An existing list name or Entities::List object.
          # @return response [Response] An Entities::Response object.
          def delete(list)
            params = { :list => extract_name(list) }
            perform_request(Entities::Response, 'newsletter/lists/delete.json', params)
          end

          private

          def extract_name(object)
            case object
            when ::String
              object
            when Entities::List
              object.list
            end
          end

        end

      end
    end
  end
end