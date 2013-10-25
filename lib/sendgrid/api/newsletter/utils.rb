require 'sendgrid/api/entities/list'

module Sendgrid
  module API
    module Newsletter
      module Utils

        private

        # Convert the object to an Entities::List.
        def extract_list(object)
          Entities::List.from_object(object)
        end

        # Retrieved the list name.
        def extract_listname(object)
          extract_list(object).list
        end

      end
    end
  end
end