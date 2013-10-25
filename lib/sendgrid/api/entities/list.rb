require 'sendgrid/api/entities/entity'

module Sendgrid
  module API
    module Entities
      class List < Entity

        attribute :list

        class << self

          # Convert the object to an Entities::List.
          #
          # @param object [String, Entities::List] A list name or Entities::List object
          # @return list [Entities::List] An Entities::List object
          def from_object(object)
            case object
            when ::String
              new(:list => object)
            when self
              object
            end
          end

        end

      end
    end
  end
end