require 'spec_helper'

module Sendgrid
  module API
    module Entities
      describe List do
        subject { described_class.new }

        it { should respond_to(:list) }

        describe '.from_object' do
          context 'when object is a String' do
            let(:object) { 'my list name' }
            subject { described_class.from_object(object) }
            it { should be_instance_of(described_class) }
            its(:list) { should == object }
          end

          context 'when object is a List' do
            let(:object) { described_class.new(:list => 'my list name') }
            subject { described_class.from_object(object) }
            it { should == object }
          end

          context 'when object is nil' do
            let(:object) { nil }
            subject { described_class.from_object(object) }
            it { should be_nil }
          end
        end
      end
    end
  end
end