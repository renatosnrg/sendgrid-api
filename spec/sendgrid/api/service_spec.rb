require 'spec_helper'

module Sendgrid
  module API
    describe Service do

      subject { described_class.new(resource) }
      let(:resource) { double('resource') }

      its(:resource) { should == resource }

      describe '#perform_request' do
        before do
          entity.should_receive(:from_response).and_return(response)
        end
        let(:entity) { double('entity') }
        let(:response) { double('response') }
        let(:url) { double('url') }

        context 'with params' do
          before do
            resource.should_receive(:post).with(url, params)
          end
          let(:params) { double('params') }

          it 'should perform a request' do
            subject.perform_request(entity, url, params).should == response
          end
        end

        context 'without params' do
          before do
            resource.should_receive(:post).with(url, {})
          end

          it 'should perform a request' do
            subject.perform_request(entity, url).should == response
          end
        end
      end

    end
  end
end
