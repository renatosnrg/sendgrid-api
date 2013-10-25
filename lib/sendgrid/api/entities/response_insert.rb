require 'sendgrid/api/entities/entity'

module Sendgrid
  module API
    module Entities
      class ResponseInsert < Entity

        attribute :inserted

        # Return true if one or more inserts were made
        def any?
          inserted > 0
        end

        # Return true if no inserts were made
        def none?
          !any?
        end

      end
    end
  end
end