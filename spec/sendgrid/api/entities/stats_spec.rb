require 'spec_helper'

module Sendgrid
  module API
    module Entities
      describe Stats do
        subject { described_class.new }

        it { should respond_to(:delivered) }
        it { should respond_to(:request) }
        it { should respond_to(:unique_open) }
        it { should respond_to(:unique_click) }
        it { should respond_to(:processed) }
        it { should respond_to(:date) }
        it { should respond_to(:open) }
        it { should respond_to(:click) }
        it { should respond_to(:blocked) }
        it { should respond_to(:spamreport) }
        it { should respond_to(:drop) }
        it { should respond_to(:bounce) }
        it { should respond_to(:deferred) }
      end
    end
  end
end