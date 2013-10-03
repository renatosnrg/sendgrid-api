require 'json'

module Sendgrid
  module API
    module Entities
      class Entity

        attr_reader :attributes

        def initialize(attributes = {})
          @attributes = sanitize_attributes(attributes)
        end

        def to_json
          as_json.to_json
        end

        def as_json
          attributes
        end

        def method_missing(method, *args, &block)
          setter = method.to_s.gsub(/=$/, '').to_sym
          if has_attribute?(method)
            attributes[method]
          elsif has_attribute?(setter)
            attributes[setter] = args.first
          else
            super
          end
        end

        private

        def has_attribute?(attribute)
          self.class.attributes.include?(attribute)
        end

        def sanitize_attributes(attributes)
          attributes.reject { |key, value| !has_attribute?(key) }
        end

        class << self

          # Instantiate the entity from API response body.
          # Can generate multiple entities if response is an Array.
          def from_response(response)
            body = response.body
            if body.is_a?(Array)
              body.map { |item| new(item) }
            elsif body.is_a?(Hash)
              new(body)
            else
              nil
            end
          end

          # Add attributes to the entity
          def attribute(*args)
            @attributes = attributes
            @attributes += args
            @attributes.uniq!
          end

          # Get the entity attributes
          def attributes
            @attributes ||= []
          end

          def clear_attributes
            @attributes = []
          end

        end

      end
    end
  end
end