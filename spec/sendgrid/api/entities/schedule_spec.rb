require 'spec_helper'

module Sendgrid
  module API
    module Entities
      describe Schedule do
        subject { described_class.new }

        it { should respond_to(:date) }

      end
    end
  end
end