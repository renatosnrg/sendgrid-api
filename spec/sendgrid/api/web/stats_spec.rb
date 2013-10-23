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

              it 'should perform the request' do
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
                its(:open) { pending('should debug open method') }
                its(:click) { should == 11 }
                its(:blocked) { should == 29 }
              end
            end

            context 'when permission failed' do
              before do
                sg_mock.stub_post(url).to_return(:body => fixture('forbidden.json'), :status => 403)
              end

              it 'should raise error' do
                expect { service.advanced }.to raise_error(REST::Errors::Forbidden)
              end
            end
          end

        end
      end
    end
  end
end