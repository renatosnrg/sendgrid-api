require 'sendgrid/api/rest/resource'
require 'sendgrid/api/web/profile'
require 'sendgrid/api/web/stats'
require 'sendgrid/api/newsletter/lists'
require 'sendgrid/api/newsletter/emails'
require 'sendgrid/api/newsletter/sender_addresses'
require 'sendgrid/api/newsletter/categories'
require 'sendgrid/api/newsletter/marketing_emails'
require 'sendgrid/api/newsletter/recipients'
require 'sendgrid/api/newsletter/schedule'

module Sendgrid
  module API
    class Client

      include Web::Profile
      include Web::Stats
      include Newsletter::Lists
      include Newsletter::Emails
      include Newsletter::SenderAddresses
      include Newsletter::Categories
      include Newsletter::MarketingEmails
      include Newsletter::Recipients
      include Newsletter::Schedule

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