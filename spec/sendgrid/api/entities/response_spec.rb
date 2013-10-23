require 'spec_helper'

module Sendgrid
  module API
    module Entities
      describe Response do
        subject { described_class.new }

        it { should respond_to(:message) }
        it { should respond_to(:errors) }

        context 'message is true' do
          subject { described_class.new(:message => 'success') }

          its(:success?) { should be_true }
          its(:error?) { should be_false }
        end

        context 'message is error' do
          subject { described_class.new(:message => 'error') }

          its(:success?) { should be_false }
          its(:error?) { should be_true }
        end
      end
    end
  end
end