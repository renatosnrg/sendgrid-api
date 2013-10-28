require 'spec_helper'

module Sendgrid
  module API
    module Entities
      describe SenderAddress do
        subject { described_class.new }

        it { should respond_to(:identity) }
        it { should respond_to(:name) }
        it { should respond_to(:email) }
        it { should respond_to(:replyto) }
        it { should respond_to(:address) }
        it { should respond_to(:city) }
        it { should respond_to(:state) }
        it { should respond_to(:zip) }
        it { should respond_to(:country) }
      end
    end
  end
end