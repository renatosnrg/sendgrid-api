require 'spec_helper'

module Sendgrid
  module API
    module Entities
      describe Entity do

        subject { described_class }

        after do
          described_class.clear_attributes
        end

        describe '.clear_attributes' do
          before do
            subject.attribute :attr1
          end

          it 'should clear the attributes' do
            subject.clear_attributes
            subject.attributes.should be_empty
          end
        end

        describe '.attribute' do
          context 'when the attributes are empty' do
            before do
              subject.clear_attributes
            end

            it 'should set the entity attributes' do
              subject.attribute :attr1, :attr2
              subject.attributes.should have(2).items
            end
          end

          context 'when the attributes are not empty' do
            before do
              subject.clear_attributes
              subject.attribute :attr1
            end

            it 'should add attributes to the entity' do
              subject.attribute :attr2
              subject.attributes.should have(2).items
            end
          end

          context 'when the attributes are repeated' do
            before do
              subject.clear_attributes
              subject.attribute :attr1
            end

            it 'should add distinct attributes to the entity' do
              subject.attribute :attr1, :attr2
              subject.attributes.should have(2).items
            end
          end
        end

        describe '#attributes' do
          before do
            subject.clear_attributes
          end

          context 'without attributes' do
            its(:attributes) { should be_empty }
          end

          context 'with attributes' do
            before do
              subject.attribute :attr1, :attr2
            end

            its(:attributes) { should have(2).items }
          end
        end

        describe '.from_response' do
          context 'when response is an array' do
            before do
              response.should_receive(:body).and_return([item1, item2])
            end
            let(:response) { double('response') }
            let(:item1) { double('item').as_null_object }
            let(:item2) { double('item').as_null_object }

            subject { described_class.from_response(response) }

            it { should have(2).items }
            its([0]) { should be_instance_of(described_class) }
            its([1]) { should be_instance_of(described_class) }
          end

          context 'when response is a hash' do
            before do
              response.should_receive(:body).and_return(item)
            end
            let(:response) { double('response') }
            let(:item) { Hash.new }

            subject { described_class.from_response(response) }

            it { should be_instance_of(described_class) }
          end

          context 'when response is a string' do
            before do
              response.should_receive(:body).and_return(item)
            end
            let(:response) { double('response') }
            let(:item) { 'some string' }

            subject { described_class.from_response(response) }

            it { should be_nil }
          end

          context 'when response is a number' do
            before do
              response.should_receive(:body).and_return(item)
            end
            let(:response) { double('response') }
            let(:item) { 45 }

            subject { described_class.from_response(response) }

            it { should be_nil }
          end

          context 'when response is a nil object' do
            before do
              response.should_receive(:body).and_return(item)
            end
            let(:response) { double('response') }
            let(:item) { nil }

            subject { described_class.from_response(response) }

            it { should be_nil }
          end
        end

        describe '.new' do
          before do
            described_class.attribute :attr1, :attr2
          end

          context 'creating entity with no attributes' do
            subject { entity }
            let(:entity) { described_class.new }
            let(:attr1) { 'attr1 value' }
            let(:attr2) { 'attr2 value' }

            its(:attr1) { should be_nil }
            its(:attr2) { should be_nil }

            it 'should raise error for invalid attributes' do
              expect { subject.attr3 }.to raise_error(NameError)
            end

            it 'should set attr1' do
              subject.attr1 = 'attr1 value'
              subject.attr1.should == 'attr1 value'
            end

            it 'should set attr2' do
              subject.attr1 = 'attr2 value'
              subject.attr1.should == 'attr2 value'
            end

            describe '#attributes' do
              subject { entity.attributes }

              it { should be_empty }
            end

            describe '#as_json' do
              subject { entity.as_json }

              it { should be_empty }
            end

            describe '#to_json' do
              subject { JSON.parse(entity.to_json) }

              it { should be_empty }
            end
          end

          context 'creating entity with valid attributes' do
            subject { entity }
            let(:entity) { described_class.new(:attr1 => attr1, :attr2 => attr2) }
            let(:attr1) { 'attr1 value' }
            let(:attr2) { 'attr2 value' }

            its(:attr1) { should == attr1 }
            its(:attr2) { should == attr2 }

            describe '#attributes' do
              subject { entity.attributes }

              it { should have(2).items }
              it { should include(:attr1) }
              it { should include(:attr2) }
              it { should_not include(:attr3) }
            end

            describe '#as_json' do
              subject { entity.as_json }

              it { should have(2).items }
              it { should include(:attr1) }
              it { should include(:attr2) }
              it { should_not include(:attr3) }
            end

            describe '#to_json' do
              subject { JSON.parse(entity.to_json) }

              it { should have(2).items }
              it { should include('attr1') }
              it { should include('attr2') }
              it { should_not include('attr3') }
            end
          end

          context 'creating entity with invalid attributes' do
            subject { entity }
            let(:entity) { described_class.new(:attr1 => attr1, :attr2 => attr2, :attr3 => attr3) }
            let(:attr1) { 'attr1 value' }
            let(:attr2) { 'attr2 value' }
            let(:attr3) { 'attr3 value' }

            its(:attr1) { should == attr1 }
            its(:attr2) { should == attr2 }

            it 'should raise error for invalid attributes' do
              expect { subject.attr3 }.to raise_error(NameError)
            end

            describe '#attributes' do
              subject { entity.attributes }

              it { should have(2).items }
              it { should include(:attr1) }
              it { should include(:attr2) }
              it { should_not include(:attr3) }
            end

            describe '#as_json' do
              subject { entity.as_json }

              it { should have(2).items }
              it { should include(:attr1) }
              it { should include(:attr2) }
              it { should_not include(:attr3) }
            end

            describe '#to_json' do
              subject { JSON.parse(entity.to_json) }

              it { should have(2).items }
              it { should include('attr1') }
              it { should include('attr2') }
              it { should_not include('attr3') }
            end
          end
        end

      end
    end
  end
end
