require 'spec_helper'

module Sendgrid
  module API
    module Web
      module Stats
        describe Services do

          subject { service }
          let(:service) { described_class.new(resource) }
          let(:resource) { REST::Resource.new(user, key) }
          let(:user) { 'my_user' }
          let(:key) { 'my_key' }
          let(:sg_mock) { Sendgrid::Mock.new(user, key) }

          describe '#advanced' do
            let(:url) { 'stats.getAdvanced.json' }

            context 'when request is successfull' do
              before do
                sg_mock.stub_post(url).to_return(:body => fixture('stats.json'))
              end

              subject { service.advanced }

              it 'performs the request' do
                subject
                sg_mock.a_post(url).should have_been_made
              end

              it { should_not be_empty }

              describe 'first result' do
                subject { service.advanced.first }

                its(:delivered) { should == 4792 }
                its(:unique_open) { should == 308 }
                its(:spamreport) { should == 3 }
                its(:unique_click) { should == 11 }
                its(:drop) { should == 57 }
                its(:request) { should == 5359 }
                its(:bounce) { should == 622 }
                its(:deferred) { should == 1975 }
                its(:processed) { should == 5302 }
                its(:date) { should == '2013-06-18' }
                its(:open) { pending('debugs open method') }
                its(:click) { should == 11 }
                its(:blocked) { should == 29 }
              end
            end

            context 'when permission failed' do
              before do
                sg_mock.stub_post(url).to_return(:body => fixture('forbidden.json'), :status => 403)
              end

              it 'raises error' do
                expect { service.advanced }.to raise_error(REST::Errors::Forbidden)
              end
            end
          end

          describe 'online tests', :online => true do
            include_examples 'online tests'

            context 'when credentials are valid' do
              let(:resource) { REST::Resource.new(env_user, env_key) }

              describe '#advanced' do
                context 'with required params' do
                  # 90 days from now
                  let(:start_date) { (Time.now - (90*24*60*60)).strftime("%Y-%m-%d") }

                  it 'gets stats' do
                    subject.advanced(:start_date => start_date, :data_type => :global).should_not be_empty
                  end
                end

                context 'without required params' do
                  it 'raises error' do
                    expect { subject.advanced }.to raise_error(REST::Errors::BadRequest)
                  end
                end
              end
            end

            context 'when credentials are invalid' do
              describe '#advanced' do
                it 'raises error' do
                  expect { subject.advanced }.to raise_error(REST::Errors::Forbidden)
                end
              end
            end
          end

        end
      end
    end
  end
end