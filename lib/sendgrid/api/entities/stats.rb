require 'sendgrid/api/entities/entity'

module Sendgrid
  module API
    module Entities
      class Stats < Entity

        attribute :delivered, :request, :unique_open, :unique_click, :processed, :date, :open, :click

      end
    end
  end
end