require 'spec_helper'

module Sendgrid
  module API
    module Newsletter
      module Emails
        describe Services do

          subject { service }
          let(:service) { described_class.new(resource) }
          let(:resource) { REST::Resource.new(user, key) }
          let(:user) { 'my_user' }
          let(:key) { 'my_key' }
          let(:sg_mock) { Sendgrid::Mock.new(user, key) }

          let(:listname) { 'my list' }
          let(:email) { Entities::Email.new(:email => 'john@example.com', :name => 'John') }
          let(:email2) { Entities::Email.new(:email => 'brian@example.com', :name => 'Brian') }
          let(:emails) { [email, email2] }

          describe '#add' do
            let(:url) { 'newsletter/lists/email/add.json' }

            context 'when add an email successfully' do
              before do
                sg_mock.stub_post(url, :list => listname, :data => [email.to_json]).
                  to_return(:body => {:inserted => 1}.to_json)
              end
              subject { service.add(listname, email) }
              its(:inserted) { should == 1 }
              its(:any?) { should be_true }
              its(:none?) { should be_false }
            end

            context 'when add multiple emails successfully' do
              before do
                sg_mock.stub_post(url, :list => listname, :data => emails.map(&:to_json)).
                  to_return(:body => {:inserted => 2}.to_json)
              end
              subject { service.add(listname, emails) }
              its(:inserted) { should == 2 }
              its(:any?) { should be_true }
              its(:none?) { should be_false }
            end

            context 'when add an email that already exists' do
              before do
                sg_mock.stub_post(url, :list => listname, :data => [email.to_json]).
                  to_return(:body => {:inserted => 0}.to_json)
              end
              subject { service.add(listname, email) }
              its(:inserted) { should == 0 }
              its(:any?) { should be_false }
              its(:none?) { should be_true }
            end

            context 'when permission failed' do
              before do
                sg_mock.stub_post(url, :list => listname, :data => [email.to_json]).
                  to_return(:body => fixture('errors/forbidden.json'), :status => 403)
              end
              subject { service.add(listname, email) }
              it 'raises error' do
                expect { subject }.to raise_error(REST::Errors::Forbidden)
              end
            end
          end

          describe '#get' do
            let(:url) { 'newsletter/lists/email/get.json' }

            context 'when get all emails successfully' do
              before do
                sg_mock.stub_post(url, :list => listname).
                  to_return(:body => fixture('emails/emails.json'))
              end
              let(:response) { service.get(listname) }
              subject { response }
              it { should have(2).items }
              describe 'first result' do
                subject { response.first }
                its(:email) { should == 'john@example.com' }
                its(:name) { should == 'John' }
              end
            end

            context 'when get an email successfully' do
              before do
                sg_mock.stub_post(url, :list => listname, :email => [email.email]).
                  to_return(:body => fixture('emails/email.json'))
              end
              let(:response) { service.get(listname, email) }
              subject { response }
              it { should have(1).item }
              describe 'first result' do
                subject { response.first }
                its(:email) { should == 'john@example.com' }
                its(:name) { should == 'John' }
              end
            end

            context 'when permission failed' do
              before do
                sg_mock.stub_post(url, :list => listname).
                  to_return(:body => fixture('errors/forbidden.json'), :status => 403)
              end
              subject { service.get(listname) }
              it 'raises error' do
                expect { subject }.to raise_error(REST::Errors::Forbidden)
              end
            end
          end

          describe '#delete' do
            let(:url) { 'newsletter/lists/email/delete.json' }

            context 'when delete an email successfully' do
              before do
                sg_mock.stub_post(url, :list => listname, :email => [email.email]).
                  to_return(:body =>  {:removed => 1}.to_json)
              end
              let(:response) { service.delete(listname, email) }
              subject { response }
              its(:removed) { should == 1 }
              its(:any?) { should be_true }
              its(:none?) { should be_false }
            end

            context 'when delete multiple emails successfully' do
              before do
                sg_mock.stub_post(url, :list => listname, :email => emails.map(&:email)).
                  to_return(:body =>  {:removed => 2}.to_json)
              end
              let(:response) { service.delete(listname, emails) }
              subject { response }
              its(:removed) { should == 2 }
              its(:any?) { should be_true }
              its(:none?) { should be_false }
            end

            context 'when no emails were deleted' do
              before do
                sg_mock.stub_post(url, :list => listname, :email => [email.email]).
                  to_return(:body =>  {:removed => 0}.to_json)
              end
              let(:response) { service.delete(listname, email) }
              subject { response }
              its(:removed) { should == 0 }
              its(:any?) { should be_false }
              its(:none?) { should be_true }
            end

            context 'when permission failed' do
              before do
                sg_mock.stub_post(url, :list => listname, :email => [email.email]).
                  to_return(:body => fixture('errors/forbidden.json'), :status => 403)
              end
              subject { service.delete(listname, email) }
              it 'raises error' do
                expect { subject }.to raise_error(REST::Errors::Forbidden)
              end
            end
          end

          describe 'online tests', :online => true do
            include_examples 'online tests'
            let(:listname) { 'sendgrid-api list test' }

            context 'when credentials are valid' do
              let(:lists) { Newsletter::Lists::Services.new(resource) }
              let(:resource) { REST::Resource.new(env_user, env_key) }

              before do
                lists.add(listname).success? or raise 'could not create the list'
              end
              after do
                lists.delete(listname).success? or raise 'could not remove the created list'
              end

              describe '#add' do
                context 'when add an email successfully' do
                  it 'adds the email' do
                    response = subject.add(listname, email)
                    response.any?.should be_true
                    response.inserted.should == 1
                  end
                end

                context 'when add multiple emails successfully' do
                  it 'adds the emails' do
                    response = subject.add(listname, emails)
                    response.any?.should be_true
                    response.inserted.should == 2
                  end
                end

                context 'when add an email that already exists' do
                  before do
                    subject.add(listname, email)
                  end
                  it 'do not add the email' do
                    response = subject.add(listname, email)
                    response.any?.should be_false
                    response.inserted.should == 0
                  end
                end
              end

              describe '#get' do
                before do
                  service.add(listname, emails)
                end

                context 'when get all emails successfully' do
                  it 'gets the emails' do
                    response = subject.get(listname)
                    response.should have(2).items
                  end
                end

                context 'when get an email successfully' do
                  it 'gets the email' do
                    response = subject.get(listname, email)
                    response.should have(1).item
                  end
                end
              end

              describe '#delete' do
                before do
                  service.add(listname, emails)
                end

                context 'when delete an email successfully' do
                  it 'deletes the email' do
                    response = service.delete(listname, email)
                    response.any?.should be_true
                    response.removed.should == 1
                  end
                end

                context 'when delete multiple emails successfully' do
                  it 'deletes the emails' do
                    response = service.delete(listname, emails)
                    response.any?.should be_true
                    response.removed.should == 2
                  end
                end
              end
            end

            context 'when credentials are invalid' do
              describe '#add' do
                it 'raises an error' do
                  expect { subject.add(listname, email) }.to raise_error(REST::Errors::Forbidden)
                end
              end

              describe '#get' do
                it 'raises an error' do
                  expect { subject.get(listname, email) }.to raise_error(REST::Errors::Forbidden)
                end
              end

              describe '#delete' do
                it 'raises an error' do
                  expect { subject.delete(listname, email) }.to raise_error(REST::Errors::Forbidden)
                end
              end
            end
          end

        end
      end
    end
  end
end