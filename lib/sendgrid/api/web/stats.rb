require 'sendgrid/api/service'
require 'sendgrid/api/entities/stats'

module Sendgrid
  module API
    module Web
      module Stats

        def stats
          Services.new(resource)
        end

        class Services < Sendgrid::API::Service

          # Get Advanced Statistics
          #
          # @see http://sendgrid.com/docs/API_Reference/Web_API/Statistics/statistics_advanced.html
          # @param options [Hash] A customizable set of options.
          # @option options [String] :data_type One of the following: browsers, clients, devices, geo, global, isps. Required.
          # @option options [Date] :start_date Date format is based on aggregated_by value (default is yyyy-mm-dd). Required.
          # @option options [Date] :end_date Date format is based on aggregated_by value (default is yyyy-mm-dd).
          # @option options [String] :metric One of the following (default is all): open, click, unique_open, unique_click, processed, delivered, drop, bounce, deferred, spamreport, blocked, all.
          # @option options [String] :category Return stats for the given category.
          # @option options [String] :aggregated_by Aggregate the data by the given period (default is day): day, week or month.
          # @option options [String] :country Get stats for each region/state for the given country. Only US (United States) and CA (Canada) is supported at this time.
          # @return [Array<Entities::Stats>] An array of Entities::Stats object.
          def advanced(options = {})
            perform_request(Entities::Stats, 'stats.getAdvanced.json', options)
          end

        end

      end
    end
  end
end