require 'sendgrid/api/entities/entity'

module Sendgrid
  module API
    module Entities
      class ResponseRemove < Entity

        attribute :removed

        # Return true if one or more removals were made
        def any?
          removed > 0
        end

        # Return true if no removals were made
        def none?
          !any?
        end

      end
    end
  end
end