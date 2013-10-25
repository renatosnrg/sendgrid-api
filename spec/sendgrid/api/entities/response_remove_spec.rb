require 'spec_helper'

module Sendgrid
  module API
    module Entities
      describe ResponseRemove do
        subject { described_class.new }

        it { should respond_to(:removed) }
        
        context 'with removals' do
          subject { described_class.new(:removed => 3) }

          its(:any?) { should be_true }
          its(:none?) { should be_false }
        end

        context 'without removals' do
          subject { described_class.new(:removed => 0) }

          its(:any?) { should be_false }
          its(:none?) { should be_true }
        end

      end
    end
  end
end