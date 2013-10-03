module Sendgrid
  module API
    module REST
      module Errors

        class Error < StandardError

          class << self

            def from_response(env)
              status_error(env) || body_error(env)
            end

            private

            def status_error(env)
              body = env[:body]
              status = env[:status].to_i
              if status != 200
                message = body[:error] if body.is_a?(Hash)
                error_class(status).new(message)
              else
                nil
              end
            end

            def body_error(env)
              body = env[:body]
              if body.is_a?(Hash) && body.has_key?(:error)
                status = body[:error][:code]
                message = body[:error][:message]
                error_class(status).new(message)
              else
                nil
              end
            end

            def error_class(status)
              Errors::CODES[status] || Errors::Unknown
            end

          end

        end

        class BadRequest < Error; end
        class Unauthorized < Error; end
        class Forbidden < Error; end
        class Unknown < Error; end

        CODES = {
          400 => BadRequest,
          401 => Unauthorized,
          403 => Forbidden,
        }.freeze

      end
    end
  end
end