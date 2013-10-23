module Sendgrid
  module API
    class Service

      attr_reader :resource

      def initialize(resource)
        @resource = resource
      end

      def perform_request(entity, url, params = {})
        entity.from_response(request(url, params))
      end

      private

      def request(url, params = {})
        resource.post(url, params)
      end

    end
  end
end
