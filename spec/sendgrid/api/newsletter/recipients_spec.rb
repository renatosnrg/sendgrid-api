require 'spec_helper'

module Sendgrid
  module API
    module Newsletter
      module Recipients
        describe Services do

          subject { service }
          let(:service) { described_class.new(resource) }
          let(:resource) { REST::Resource.new(user, key) }
          let(:user) { 'my_user' }
          let(:key) { 'my_key' }
          let(:sg_mock) { Sendgrid::Mock.new(user, key) }

          let(:marketing_email_name) { 'my marketing email' }
          let(:listname) { 'my list' }
          let(:marketing_email) { Entities::MarketingEmail.new(:name => marketing_email_name) }
          let(:list) { Entities::List.new(:list => listname) }

          describe '#add' do
            let(:url) { 'newsletter/recipients/add.json' }
            let(:stub_post) { sg_mock.stub_post(url, :name => marketing_email_name, :list => listname) }
            subject { service.add(list, marketing_email) }

            context 'when add a recipient list successfully' do
              context 'with object' do
                it_behaves_like 'a success response'
              end

              context 'with name' do
                subject { service.add(listname, marketing_email_name) }
                it_behaves_like 'a success response'
              end
            end

            context 'when the list does not exist' do
              it_behaves_like 'a database error response'
            end

            context 'when the marketing email does not exist' do
              it_behaves_like 'a does not exist response'
            end

            context 'when permission failed' do
              it_behaves_like 'a forbidden response'
            end
          end

          describe '#get' do
            let(:url) { 'newsletter/recipients/get.json' }
            let(:stub_post) { sg_mock.stub_post(url, :name => marketing_email_name) }
            subject { service.get(marketing_email) }

            context 'when get the recipient lists successfully' do
              before do
                stub_post.to_return(:body => fixture('recipients.json'))
              end

              context 'with object' do
                it { should have(2).items }

                describe 'first item' do
                  subject { service.get(marketing_email).first }
                  its(:list) { should == 'list 1' }
                end
              end

              context 'with name' do
                subject { service.get(marketing_email_name) }

                it { should have(2).items }
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
            let(:url) { 'newsletter/recipients/delete.json' }
            let(:stub_post) { sg_mock.stub_post(url, :name => marketing_email_name, :list => listname) }
            subject { service.delete(list, marketing_email) }

            context 'when delete a recipient list successfully' do
              context 'with object' do
                it_behaves_like 'a success response'
              end

              context 'with name' do
                subject { service.delete(listname, marketing_email_name) }
                it_behaves_like 'a success response'
              end
            end

            context 'when the list does not exist' do
              it_behaves_like 'a database error response'
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
            let(:list) { online.list_example }
            let(:client) { online.client }

            context 'when credentials are valid' do
              let(:resource) { REST::Resource.new(env_user, env_key) }

              describe '#add' do
                context 'when add a recipient list successfully' do
                  before do
                    online.add_marketing_email
                    online.add_list
                  end
                  after do
                    online.delete_marketing_email
                    online.delete_list
                  end

                  it 'adds the recipient list' do
                    online.add_recipient_list.should be_true
                  end
                end

                context 'when the list does not exist' do
                  before do
                    online.add_marketing_email
                  end
                  after do
                    online.delete_marketing_email
                  end
                  it 'raises an error' do
                    expect { subject.add(list, marketing_email) }.to raise_error(REST::Errors::Unknown)
                  end
                end

                context 'when the marketing email does not exist' do
                  before do
                    online.add_list
                  end
                  after do
                    online.delete_list
                  end
                  it 'raises an error' do
                    expect { subject.add(list, marketing_email) }.to raise_error(REST::Errors::Unauthorized)
                  end
                end
              end

              describe '#get' do
                context 'when get the recipient lists successfully' do
                  before do
                    online.add_marketing_email
                  end
                  after do
                    online.delete_marketing_email
                  end
                  it 'gets the recipient lists' do
                    expect { subject.get(marketing_email) }.to_not raise_error
                  end
                end

                context 'when the marketing email does not exist' do
                  it 'raises an error' do
                    expect { subject.get(marketing_email) }.to raise_error(REST::Errors::Unauthorized)
                  end
                end
              end

              describe '#delete' do
                context 'when delete a recipient list successfully' do
                  before do
                    online.add_marketing_email
                    online.add_list
                    online.add_recipient_list
                  end
                  after do
                    online.delete_marketing_email
                    online.delete_list
                  end

                  it 'deletes the recipient list' do
                    subject.delete(list, marketing_email).success?.should be_true
                  end
                end

                context 'when the list does not exist' do
                  before do
                    online.add_marketing_email
                  end
                  after do
                    online.delete_marketing_email
                  end
                  it 'raises an error' do
                    expect { subject.delete(list, marketing_email) }.to raise_error(REST::Errors::Unknown)
                  end
                end

                context 'when the marketing email does not exist' do
                  before do
                    online.add_list
                  end
                  after do
                    online.delete_list
                  end
                  it 'raises an error' do
                    expect { subject.delete(list, marketing_email) }.to raise_error(REST::Errors::Unauthorized)
                  end
                end
              end
            end

            context 'when credentials are invalid' do
              describe '#add' do
                it 'raises an error' do
                  expect { subject.add(list, marketing_email) }.to raise_error(REST::Errors::Forbidden)
                end
              end

              describe '#get' do
                it 'raises an error' do
                  expect { subject.get(marketing_email) }.to raise_error(REST::Errors::Forbidden)
                end
              end

              describe '#delete' do
                it 'raises an error' do
                  expect { subject.delete(list, marketing_email) }.to raise_error(REST::Errors::Forbidden)
                end
              end
            end
          end
        end
      end
    end
  end
end