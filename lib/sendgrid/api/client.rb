require 'sendgrid/api/rest/resource'
require 'sendgrid/api/web/profile'
require 'sendgrid/api/web/stats'

module Sendgrid
  module API
    class Client

      include Web::Profile
      include Web::Stats

      attr_reader :user, :key

      def initialize(user, key)
        @user = user
        @key = key
      end

      private

      def resource
        @resource ||= REST::Resource.new(user, key)
      end

    end
  end
end