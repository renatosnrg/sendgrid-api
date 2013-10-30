require 'sendgrid/api/service'
require 'sendgrid/api/entities/category'
require 'sendgrid/api/entities/response'
require 'sendgrid/api/newsletter/utils'

module Sendgrid
  module API
    module Newsletter
      module Categories

        def categories
          Services.new(resource)
        end

        class Services < Sendgrid::API::Service
          include Newsletter::Utils

          # Create a new Category.
          #
          # @see http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/categories.html#-create
          # @param category [String, Entities::Category] A category name or Entities::Category object.
          # @return [Response] An Entities::Response object.
          def create(category)
            params = { :category => extract_category(category) }
            perform_request(Entities::Response, 'newsletter/category/create.json', params)
          end

          # Assign a Category to an existing Marketing Email.
          #
          # @see http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/categories.html#-add
          # @param marketing_email [String, Entities::MarketingEmail] An existing marketing email name or Entities::MarketingEmail object.
          # @param category [String, Entities::Category] A category name or Entities::Category object.
          # @return [Response] An Entities::Response object.
          def add(marketing_email, category)
            params = { :name => extract_marketing_email(marketing_email), :category => extract_category(category) }
            perform_request(Entities::Response, 'newsletter/category/add.json', params)
          end

          # Remove specific categories, or all categories from a Marketing Email.
          #
          # @see http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/categories.html#-remove
          # @param marketing_email [String, Entities::MarketingEmail] An existing marketing email name or Entities::MarketingEmail object.
          # @param category [String, Entities::Category] A category name or Entities::Category object.
          # @return [Response] An Entities::Response object.
          def remove(marketing_email, category)
            params = { :name => extract_marketing_email(marketing_email), :category => extract_category(category) }
            perform_request(Entities::Response, 'newsletter/category/remove.json', params)
          end

          # List all categories.
          #
          # @see http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/categories.html#-list
          # @return [Array<Category>] An array of Entities::Category objects.
          def list
            perform_request(Entities::Category, 'newsletter/category/list.json')
          end

          private

          def extract_category(category)
            case category
            when ::String
              category
            when Entities::Category
              category.category
            end
          end

        end

      end
    end
  end
end