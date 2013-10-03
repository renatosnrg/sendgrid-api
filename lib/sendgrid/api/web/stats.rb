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
          # @return stats [Stats] An array of Web::Stats object.
          def advanced(params = {})
            perform_request(Entities::Stats, 'stats.getAdvanced.json', params)
          end

        end

      end
    end
  end
end