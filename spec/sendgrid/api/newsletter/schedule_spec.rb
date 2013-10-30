require 'spec_helper'

module Sendgrid
  module API
    module Newsletter
      module Schedule
        describe Services do

          subject { service }
          let(:service) { described_class.new(resource) }
          let(:resource) { REST::Resource.new(user, key) }
          let(:user) { 'my_user' }
          let(:key) { 'my_key' }
          let(:sg_mock) { Sendgrid::Mock.new(user, key) }

          let(:marketing_email_name) { 'my marketing email' }
          let(:marketing_email) { Entities::MarketingEmail.new(:name => marketing_email_name) }

          describe '#add' do
            let(:url) { 'newsletter/schedule/add.json' }
            let(:stub_post) { sg_mock.stub_post(url, :name => marketing_email_name) }
            subject { service.add(marketing_email) }

            context 'when add a schedule successfully' do
              context 'with object' do
                it_behaves_like 'a success response'
              end

              context 'with name' do
                subject { service.add(marketing_email_name) }
                it_behaves_like 'a success response'
              end

              context 'with options' do
                let(:at) { Time.now.to_s }
                let(:after) { 10 }
                let(:stub_post) { sg_mock.stub_post(url, :name => marketing_email_name, :at => at, :after => after.to_s) }
                subject { service.add(marketing_email_name, :at => at, :after => after) }
                it_behaves_like 'a success response'
              end

              context 'with invalid options' do
                let(:other) { 'other' }
                let(:stub_post) { sg_mock.stub_post(url, :name => marketing_email_name) }
                subject { service.add(marketing_email_name, :other => other) }
                it_behaves_like 'a success response'
              end
            end

            context 'when the schedule params are invalid' do
              it_behaves_like 'an invalid fields response'
            end

            context 'when the marketing email does not exist' do
              it_behaves_like 'a does not exist response'
            end

            context 'when permission failed' do
              it_behaves_like 'a forbidden response'
            end
          end

          describe '#get' do
            let(:url) { 'newsletter/schedule/get.json' }
            let(:stub_post) { sg_mock.stub_post(url, :name => marketing_email_name) }
            subject { service.get(marketing_email) }

            context 'when get the schedule successfully' do
              before do
                stub_post.to_return(:body => fixture('schedule.json'))
              end

              context 'with object' do
                its(:date) { should == '2013-10-30 18:01:40' }
              end

              context 'with name' do
                subject { service.get(marketing_email_name) }
                its(:date) { should == '2013-10-30 18:01:40' }
              end
            end

            context 'when the marketing email does not exist' do
              it_behaves_like 'a does not exist response'
            end

            context 'when permission failed' do
              it_behaves_like 'a forbidden response'
            end
          end

          describe '#delete' do
            let(:url) { 'newsletter/schedule/delete.json' }
            let(:stub_post) { sg_mock.stub_post(url, :name => marketing_email_name) }
            subject { service.delete(marketing_email) }

            context 'when delete the schedule successfully' do
              context 'with object' do
                it_behaves_like 'a success response'
              end

              context 'with name' do
                subject { service.delete(marketing_email_name) }
                it_behaves_like 'a success response'
              end
            end

            context 'when there is no previous schedule' do
              it_behaves_like 'a not scheduled response'
            end

            context 'when the marketing email does not exist' do
              it_behaves_like 'a does not exist response'
            end

            context 'when permission failed' do
              it_behaves_like 'a forbidden response'
            end
          end

          describe 'online tests', :online => true do
            include_examples 'online tests'
            let(:online) { Online.new(env_user, env_key) }
            let(:marketing_email) { online.marketing_email_example }
            let(:client) { online.client }

            context 'when credentials are valid' do
              let(:resource) { REST::Resource.new(env_user, env_key) }

              describe '#add' do
                context 'when add a schedule successfully' do
                  before do
                    online.add_marketing_email_with_list
                  end
                  after do
                    online.delete_marketing_email_with_list
                  end
                  it 'schedules a marketing email' do
                    subject.add(marketing_email, :after => 10).success?.should be_true
                  end
                end

                context 'when the schedule params are invalid' do
                  before do
                    online.add_marketing_email
                  end
                  after do
                    online.delete_marketing_email
                  end
                  it 'raises an error' do
                    expect { subject.add(marketing_email, :at => '2013') }.to raise_error(REST::Errors::BadRequest)
                  end
                end

                context 'when the marketing email does not exist' do
                  it 'raises an error' do
                    expect { subject.add(marketing_email) }.to raise_error(REST::Errors::Unauthorized)
                  end
                end
              end

              describe '#get' do
                context 'when get the schedule successfully' do
                  before do
                    online.add_marketing_email_with_list
                    subject.add(marketing_email, :after => 10)
                  end
                  after do
                    online.delete_marketing_email_with_list
                  end
                  it 'gets the schedule' do
                    subject.get(marketing_email).date.should_not be_empty
                  end
                end

                context 'when the marketing email does not exist' do
                  it 'raises an error' do
                    expect { subject.get(marketing_email) }.to raise_error(REST::Errors::Unauthorized)
                  end
                end
              end

              describe '#delete' do
                context 'when delete the schedule successfully' do
                  before do
                    online.add_marketing_email_with_list
                    subject.add(marketing_email, :after => 10)
                  end
                  after do
                    online.delete_marketing_email_with_list
                  end
                  it 'deletes the schedule' do
                    subject.delete(marketing_email).success?.should be_true
                  end
                end

                context 'when there is no previous schedule' do
                  before do
                    online.add_marketing_email
                  end
                  after do
                    online.delete_marketing_email
                  end
                  it 'raises an error' do
                    expect { subject.delete(marketing_email) }.to raise_error(REST::Errors::Unauthorized)
                  end
                end

                context 'when the marketing email does not exist' do
                  it 'raises an error' do
                    expect { subject.delete(marketing_email) }.to raise_error(REST::Errors::Unauthorized)
                  end
                end
              end
            end

            context 'when credentials are invalid' do
              describe '#add' do
                it 'raises an error' do
                  expect { subject.add(marketing_email) }.to raise_error(REST::Errors::Forbidden)
                end
              end

              describe '#get' do
                it 'raises an error' do
                  expect { subject.get(marketing_email) }.to raise_error(REST::Errors::Forbidden)
                end
              end

              describe '#delete' do
                it 'raises an error' do
                  expect { subject.delete(marketing_email) }.to raise_error(REST::Errors::Forbidden)
                end
              end
            end
          end
        end
      end
    end
  end
end