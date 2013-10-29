require 'sendgrid/api/entities/entity'

module Sendgrid
  module API
    module Entities
      class MarketingEmail < Entity

        # required attributes to create
        attribute :identity, :name, :subject, :text, :html

        # other attributes
        attribute :can_edit, :content_preview, :date_schedule, 
                  :is_deleted, :is_split, :is_winner, :newsletter_id, 
                  :nl_type, :timezone_id, :total_recipients,
                  :type, :winner_sending_time

      end
    end
  end
end