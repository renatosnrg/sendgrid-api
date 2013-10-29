require 'spec_helper'

module Sendgrid
  module API
    module Entities
      describe Category do
        subject { described_class.new }

        it { should respond_to(:category) }

      end
    end
  end
end