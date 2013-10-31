require 'sendgrid/api/service'
require 'sendgrid/api/entities/response'

module Sendgrid
  module API
    module Web
      module Mail

        def mail
          Services.new(resource)
        end

        class Services < Sendgrid::API::Service

          # Send email.
          #
          # @see http://sendgrid.com/docs/API_Reference/Web_API/mail.html#-send
          # @param options [Hash] A customizable set of options.
          # @option options [String]  :to         Must be a valid email address. This can also be passed in as an array, to send to multiple locations.
          # @option options [String]  :toname     Give a name to the recipient. This can also be passed as an array if the to above is an array.
          # @option options [String]  :x_smtpapi  Must be in valid JSON format. See http://sendgrid.com/docs/API_Reference/SMTP_API/index.html.
          # @option options [String]  :subject    The subject of your email.
          # @option options [String]  :text       The actual content of your email message. It can be sent as either plain text or HTML for the user to display.
          # @option options [String]  :html       The actual content of your email message. It can be sent as either plain text or HTML for the user to display.
          # @option options [String]  :from       This is where the email will appear to originate from for your recipient.
          # @option options [String]  :bcc        This can also be passed in as an array of email addresses for multiple recipients.
          # @option options [String]  :fromname   This is name appended to the from email field.
          # @option options [String]  :replyto    Append a reply-to field to your email message.
          # @option options [String]  :date       Specify the date header of your email.
          # @option options [String]  :files      Files to be attached.
          # @option options [String]  :content    Content IDs of the files to be used as inline images.
          # @option options [String]  :headers    A collection of key/value pairs in JSON format.
          # @return [Response] An Entities::Response object.
          def send(options = {})
            options['x-smtpapi'] = options.delete(:x_smtpapi) if options.member?(:x_smtpapi)
            perform_request(Entities::Response, 'mail.send.json', options)
          end

        end

      end
    end
  end
end