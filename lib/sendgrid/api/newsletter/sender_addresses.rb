require 'sendgrid/api/service'
require 'sendgrid/api/entities/sender_address'
require 'sendgrid/api/entities/response'

module Sendgrid
  module API
    module Newsletter
      module SenderAddresses

        def sender_addresses
          Services.new(resource)
        end

        class Services < Sendgrid::API::Service
          # Create a new Sender Address.
          #
          # @see http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/sender_address.html#-add
          # @param sender_address [Entities::SenderAddress] An Entities::SenderAddress object.
          # @return [Response] An Entities::Response object.
          def add(sender_address)
            perform_request(Entities::Response, 'newsletter/identity/add.json', sender_address.as_json)
          end

          # Edit an existing Sender Address.
          #
          # @see http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/sender_address.html#-edit
          # @param sender_address [Entities::SenderAddress] An existing Entities::SenderAddress object.
          # @param new_identity [String] A new identity for the existing sender address. Optional.
          # @return [Response] An Entities::Response object.
          def edit(sender_address, new_identity = nil)
            params = sender_address.as_json
            params[:newidentity] = new_identity if new_identity
            perform_request(Entities::Response, 'newsletter/identity/edit.json', params)
          end

          # Retrieve information associated with a particular Sender Address.
          #
          # @see http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/sender_address.html#-get
          # @param sender_address [String, Entities::SenderAddress] An existing sender address identity or Entities::SenderAddress object.
          # @return [SenderAddress] An Entities::SenderAddress object.
          def get(sender_address)
            params = { :identity => extract_identity(sender_address) }
            perform_request(Entities::SenderAddress, 'newsletter/identity/get.json', params)
          end

          # List all Sender Addresses on your account.
          #
          # @see http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/sender_address.html#-list
          # @return [Array<SenderAddress>] An array of Entities::SenderAddress objects.
          def list
            perform_request(Entities::SenderAddress, 'newsletter/identity/list.json')
          end

          # Remove a Sender Address from your account.
          #
          # @see http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/sender_address.html#-delete
          # @param sender_address [String, Entities::SenderAddress] An existing sender address identity or Entities::SenderAddress object.
          # @return [Response] An Entities::Response object.
          def delete(sender_address)
            params = { :identity => extract_identity(sender_address) }
            perform_request(Entities::Response, 'newsletter/identity/delete.json', params)
          end

          private

          def extract_identity(sender_address)
            case sender_address
            when ::String
              sender_address
            when Entities::SenderAddress
              sender_address.identity
            end
          end

        end

      end
    end
  end
end