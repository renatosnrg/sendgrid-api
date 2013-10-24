require 'spec_helper'

module Sendgrid
  module API
    module Entities
      describe List do
        subject { described_class.new }

        it { should respond_to(:list) }
      end
    end
  end
end