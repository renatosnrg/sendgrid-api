require 'spec_helper'

module Sendgrid
  module API
    module REST
      module Response
        describe ParseError do

          subject { described_class.new }

          describe '#on_complete' do
            context 'response with error' do
              before do
                REST::Errors::Error.should_receive(:from_response).and_return(Errors::Error)
              end
              let(:env) { double('env') }

              it 'should raise the error' do
                expect { subject.on_complete(env) }.to raise_error(Errors::Error)
              end
            end

            context 'response without error' do
              before do
                REST::Errors::Error.should_receive(:from_response).and_return(nil)
              end
              let(:env) { double('env') }

              it 'should return nil' do
                subject.on_complete(env).should be_nil
              end
            end
          end

        end
      end
    end
  end
end
