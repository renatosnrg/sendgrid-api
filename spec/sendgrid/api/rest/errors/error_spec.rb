require 'spec_helper'

module Sendgrid
  module API
    module REST
      module Errors
        describe Error do
          subject { described_class }

          describe '.from_response' do
            context 'when response has a status error' do
              context 'known status' do
                let(:env) do
                  { :status => 400,
                    :body => nil }
                end

                subject { described_class.from_response(env) }

                it { should be_instance_of(Errors::BadRequest) }
              end

              context 'unknown status' do
                let(:env) do
                  { :status => 413,
                    :body => nil }
                end

                subject { described_class.from_response(env) }

                it { should be_instance_of(Errors::Unknown) }
              end

              context 'with message' do
                let(:env) do
                  { :status => 400,
                    :body => { :error => 'error message' } }
                end

                subject { described_class.from_response(env) }

                it { should == Errors::BadRequest.new('error message') }
              end

              context 'with multiple messages' do
                let(:env) do
                  { :status => 400,
                    :body => { :errors => ['error message 1', 'error message 2'] } }
                end

                subject { described_class.from_response(env) }

                it { should == Errors::BadRequest.new('error message 1, error message 2') }
              end
            end

            context 'when response has body error' do
              context 'when error is a Hash' do
                context 'known status' do
                  let(:env) do
                    { :status => 200,
                      :body => { :error => { :code => 400 } } }
                  end

                  subject { described_class.from_response(env) }

                  it { should be_instance_of(Errors::BadRequest) }
                end

                context 'unknown status' do
                  let(:env) do
                    { :status => 200,
                      :body => { :error => { :code => 413 } } }
                  end

                  subject { described_class.from_response(env) }

                  it { should be_instance_of(Errors::Unknown) }
                end

                context 'with message' do
                  let(:env) do
                    { :status => 200,
                      :body => { :error => { :code => 400,
                                             :message => 'error message' } } }
                  end

                  subject { described_class.from_response(env) }

                  it { should == Errors::BadRequest.new('error message') }
                end
              end

              context 'when error is a String' do
                let(:env) do
                  { :status => 200,
                    :body => { :error => 'error message' } }
                end

                subject { described_class.from_response(env) }

                it { should == Errors::UnprocessableEntity.new('error message') }
              end
            end

            context 'when response has no error' do
              let(:env) do
                { :status => 200,
                  :body => nil }
              end

              subject { described_class.from_response(env) }

              it { should be_nil }
            end
          end
        end
      end
    end
  end
end