require 'spec_helper'

module Sendgrid
  module API
    module Entities
      describe MarketingEmail do
        subject { described_class.new }

        it { should respond_to(:identity) }
        it { should respond_to(:name) }
        it { should respond_to(:subject) }
        it { should respond_to(:text) }
        it { should respond_to(:html) }

        it { should respond_to(:can_edit) }
        it { should respond_to(:content_preview) }
        it { should respond_to(:date_schedule) }
        it { should respond_to(:is_deleted) }
        it { should respond_to(:is_split) }
        it { should respond_to(:is_winner) }
        it { should respond_to(:newsletter_id) }
        it { should respond_to(:nl_type) }
        it { should respond_to(:timezone_id) }
        it { should respond_to(:total_recipients) }
        it { should respond_to(:type) }
        it { should respond_to(:winner_sending_time) }

      end
    end
  end
end