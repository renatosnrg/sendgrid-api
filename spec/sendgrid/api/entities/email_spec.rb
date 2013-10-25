require 'spec_helper'

module Sendgrid
  module API
    module Entities
      describe Email do
        subject { described_class.new }

        it { should respond_to(:email) }
        it { should respond_to(:name) }

      end
    end
  end
end