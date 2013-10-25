require 'spec_helper'

module Sendgrid
  module API
    module Entities
      describe ResponseInsert do
        subject { described_class.new }

        it { should respond_to(:inserted) }
        
        context 'with inserts' do
          subject { described_class.new(:inserted => 3) }

          its(:any?) { should be_true }
          its(:none?) { should be_false }
        end

        context 'without inserts' do
          subject { described_class.new(:inserted => 0) }

          its(:any?) { should be_false }
          its(:none?) { should be_true }
        end

      end
    end
  end
end