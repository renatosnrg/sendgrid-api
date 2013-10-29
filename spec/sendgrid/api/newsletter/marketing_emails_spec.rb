require 'spec_helper'

module Sendgrid
  module API
    module Newsletter
      module MarketingEmails
        describe Services do

          subject { service }
          let(:service) { described_class.new(resource) }
          let(:resource) { REST::Resource.new(user, key) }
          let(:user) { 'my_user' }
          let(:key) { 'my_key' }
          let(:sg_mock) { Sendgrid::Mock.new(user, key) }

          let(:marketing_email) do
            Entities::MarketingEmail.new(:identity => identity, :name => name, :subject => email_subject, :text => text, :html => html)
          end
          let(:identity) { 'my identity' }
          let(:name) { 'my name' }
          let(:email_subject) { 'my subject' }
          let(:text) { 'my text' }
          let(:html) { 'my html' }

          describe '#add' do
            let(:url) { 'newsletter/add.json' }
            let(:stub_post) { sg_mock.stub_post(url, marketing_email.as_json) }
            subject { service.add(marketing_email) }

            context 'when add a marketing email successfully' do
              it_behaves_like 'a success response'
            end

            context 'when the marketing email is not valid' do
              it_behaves_like 'an invalid fields response'
            end

            context 'when a marketing email already exists' do
              it_behaves_like 'an already exists unauthorized response'
            end

            context 'when permission failed' do
              it_behaves_like 'a forbidden response'
            end
          end

          describe '#edit' do
            let(:url) { 'newsletter/edit.json' }
            let(:stub_post) { sg_mock.stub_post(url, marketing_email.as_json) }
            subject { service.edit(marketing_email) }

            context 'when edit a marketing email successfully' do
              it_behaves_like 'a success response'
            end

            context 'when edit a marketing email name successfully' do
              it_behaves_like 'a success response'
            end

            context 'when a new marketing email name already exists' do
              let(:newname) { 'my new name' }
              let(:stub_post) { sg_mock.stub_post(url, marketing_email.as_json.merge(:newname => newname)) }
              subject { service.edit(marketing_email, newname) }
              it_behaves_like 'a success response'
            end

            context 'when the marketing email is not found' do
              it_behaves_like 'a does not exist response'
            end

            context 'when permission failed' do
              it_behaves_like 'a forbidden response'
            end
          end

          describe '#get' do
            let(:url) { 'newsletter/get.json' }
            let(:stub_post) { sg_mock.stub_post(url, :name => name) }
            subject { service.get(marketing_email) }

            context 'when get a marketing email successfully' do
              before do
                stub_post.to_return(:body => fixture('marketing_emails/marketing_email.json'))
              end

              context 'with name' do
                subject { service.get(name) }
                its(:name) { should == 'sendgrid tutorial' }
                its(:subject) { should == 'SendGrid Email Marketing Service Tutorial' }
              end

              context 'with object' do
                its(:name) { should == 'sendgrid tutorial' }
                its(:subject) { should == 'SendGrid Email Marketing Service Tutorial' }
              end
            end

            context 'when the marketing email is not found' do
              it_behaves_like 'a does not exist response'
            end

            context 'when permission failed' do
              it_behaves_like 'a forbidden response'
            end
          end

          describe '#list' do
            let(:url) { 'newsletter/list.json' }
            let(:stub_post) { sg_mock.stub_post(url) }
            subject { service.list }

            context 'when get all marketing emails successfully' do
              before do
                stub_post.to_return(:body => fixture('marketing_emails/marketing_emails.json'))
              end
              it { should have(2).items } 

              describe 'first item' do
                subject { service.list.first }
                its(:name) { should == 'Sendgrid Tutorial' }
                its(:newsletter_id) { should == 123456 }
              end
            end

            context 'when permission failed' do
              it_behaves_like 'a forbidden response'
            end
          end

          describe '#delete' do
            let(:url) { 'newsletter/delete.json' }
            let(:stub_post) { sg_mock.stub_post(url, :name => name) }
            subject { service.delete(marketing_email) }

            context 'when delete a marketing email successfully' do
              context 'with name' do
                subject { service.delete(name) }
                it_behaves_like 'a success response'
              end

              context 'with object' do
                it_behaves_like 'a success response'
              end
            end

            context 'when the marketing email is not found' do
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
            let(:sender_address) { online.sender_address_example }
            let(:client) { online.client }

            context 'when credentials are valid' do
              let(:resource) { REST::Resource.new(env_user, env_key) }

              before do
                client.sender_addresses.add(sender_address)
              end
              after do
                client.sender_addresses.delete(sender_address)
              end

              describe '#add' do
                context 'when add a marketing email successfully' do
                  after do
                    subject.delete(marketing_email)
                  end
                  it 'adds the marketing email' do
                    subject.add(marketing_email).success?.should be_true
                  end
                end

                context 'when the marketing email is not valid' do
                  it 'raises an error' do
                    marketing_email.subject = nil
                    expect { subject.add(marketing_email) }.to raise_error(REST::Errors::BadRequest)
                  end
                end

                context 'when a marketing email already exists' do
                  before do
                    subject.add(marketing_email)
                  end
                  after do
                    subject.delete(marketing_email)
                  end
                  it 'raises an error' do
                    expect { subject.add(marketing_email) }.to raise_error(REST::Errors::Unauthorized)
                  end
                end
              end

              describe '#edit' do
                context 'when edit a marketing email successfully' do
                  before do
                    subject.add(marketing_email)
                  end
                  after do
                    subject.delete(marketing_email)
                  end
                  it 'edits the marketing email' do
                    subject.edit(marketing_email).success?.should be_true
                  end
                end

                context 'when the marketing email is not found' do
                  it 'raises an error' do
                    expect { subject.edit(marketing_email) }.to raise_error(REST::Errors::Unauthorized)
                  end
                end
              end

              describe '#get' do
                context 'when get a marketing email successfully' do
                  before do
                    subject.add(marketing_email)
                  end
                  after do
                    subject.delete(marketing_email)
                  end
                  it 'gets the marketing email' do
                    response = subject.get(marketing_email)
                    response.name.should == marketing_email.name
                  end
                end

                context 'when the marketing email is not found' do
                  it 'raises an error' do
                    expect { subject.get(marketing_email) }.to raise_error(REST::Errors::Unauthorized)
                  end
                end
              end

              describe '#list' do
                context 'when get all marketing emails successfully' do
                  it 'get all the marketing emails' do
                    subject.list.should_not be_empty
                  end
                end
              end

              describe '#delete' do
                context 'when delete a marketing email successfully' do
                  before do
                    subject.add(marketing_email)
                  end
                  it 'deletes the marketing email' do
                    subject.delete(marketing_email).success?.should be_true
                  end
                end

                context 'when the marketing email is not found' do
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

              describe '#edit' do
                it 'raises an error' do
                  expect { subject.edit(marketing_email) }.to raise_error(REST::Errors::Forbidden)
                end
              end

              describe '#get' do
                it 'raises an error' do
                  expect { subject.get(marketing_email) }.to raise_error(REST::Errors::Forbidden)
                end
              end

              describe '#list' do
                it 'raises an error' do
                  expect { subject.list }.to raise_error(REST::Errors::Forbidden)
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