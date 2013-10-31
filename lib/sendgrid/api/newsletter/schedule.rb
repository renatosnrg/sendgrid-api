require 'sendgrid/api/service'
require 'sendgrid/api/entities/schedule'
require 'sendgrid/api/entities/response'
require 'sendgrid/api/newsletter/utils'

module Sendgrid
  module API
    module Newsletter
      module Schedule

        def schedule
          Services.new(resource)
        end

        class Services < Sendgrid::API::Service
          include Newsletter::Utils

          # Schedule a delivery time for an existing Marketing Email.
          #
          # @see http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/schedule.html#-add
          # @param marketing_email [String, Entities::MarketingEmail] A marketing email name or Entities::MarketingEmail object.
          # @param options [Hash] A customizable set of options.
          # @option options [String] :at Date/Time to schedule marketing email Delivery. Date/Time must be provided in ISO 8601 format (YYYY-MM-DD HH:MM:SS+-HH:MM)
          # @option options [Fixnum] :after Number of minutes until delivery should occur. Must be a positive integer.
          # @return [Response] An Entities::Response object.
          def add(marketing_email, options = {})
            options.keep_if {|key, value| [:at, :after].include?(key) }
            options[:at] = format_time(options[:at]) if options.member?(:at)
            params = { :name => extract_marketing_email(marketing_email) }
            params.merge!(options) if options.any?
            perform_request(Entities::Response, 'newsletter/schedule/add.json', params)
          end

          # Retrieve the scheduled delivery time for an existing Marketing Email.
          #
          # @see http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/schedule.html#-get
          # @param marketing_email [String, Entities::MarketingEmail] A marketing email name or Entities::MarketingEmail object.
          # @return [Schedule] An Entities::Schedule objects.
          def get(marketing_email)
            params = { :name => extract_marketing_email(marketing_email) }
            perform_request(Entities::Schedule, 'newsletter/schedule/get.json', params)
          end

          # Cancel a scheduled send for a Marketing Email.
          #
          # @see http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/schedule.html#-delete
          # @param marketing_email [String, Entities::MarketingEmail] A marketing email name or Entities::MarketingEmail object.
          # @return [Response] An Entities::Response object.
          def delete(marketing_email)
            params = { :name => extract_marketing_email(marketing_email) }
            perform_request(Entities::Response, 'newsletter/schedule/delete.json', params)
          end

          private

          def format_time(at)
            case at
            when ::String
              at
            when ::Time
              at.strftime('%Y-%m-%d %H:%M:%S%:z')
            end
          end

        end

      end
    end
  end
end