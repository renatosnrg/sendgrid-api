require 'spec_helper'

module Sendgrid
  module API
    module Web
      module Mail
        describe Services do

          subject { service }
          let(:service) { described_class.new(resource) }
          let(:resource) { REST::Resource.new(user, key) }
          let(:user) { 'my_user' }
          let(:key) { 'my_key' }
          let(:sg_mock) { Sendgrid::Mock.new(user, key) }

          let(:to) { 'test@coffeebeantech.com' }
          let(:from) { 'test@coffeebeantech.com' }
          let(:email_subject) { 'sendgrid-api mail test' }
          let(:text) { 'This is an email to test the sendgrid-api gem' }
          let(:files) do
            { 'sample1.txt' => sample_file(:name => 'sample1.txt'),
              'sample2.txt' => sample_file(:name => 'sample2.txt') }
          end
          let(:x_smtpapi) do
            { :category => ['sendgrid-api test'] }.to_json
          end
          let(:required_options) do
            { :to => to, :subject => email_subject, :text => text, :from => from }
          end

          describe '#mail' do
            let(:url) { 'mail.send.json' }

            context 'with required fields' do
              let(:stub_post) { sg_mock.stub_post(url, required_options) }
              subject { service.send(required_options) }
              it_behaves_like 'a success response'
            end

            context 'without required fields' do
              let(:stub_post) { sg_mock.stub_post(url, :to => to) }
              subject { service.send(:to => to) }
              it_behaves_like 'an invalid fields response'
            end

            context 'with files attached' do
              let(:stub_post) { stub_request(:post, sg_mock.uri(url)).with(:body => /sample1.txt/) }
              subject { service.send(required_options.merge(:files => files)) }
              it_behaves_like 'a success response'
            end

            context 'with SMTP API headers' do
              let(:stub_post) { sg_mock.stub_post(url, :to => to, :subject => email_subject, :text => text, :from => from, 'x-smtpapi' => x_smtpapi) }
              subject { service.send(required_options.merge(:x_smtpapi => x_smtpapi)) }
              it_behaves_like 'a success response'
            end

            context 'when permission failed' do
              let(:stub_post) { sg_mock.stub_post(url) }
              subject { service.send }
              it_behaves_like 'a bad request response'
            end
          end

          describe 'online tests', :online => true do
            include_examples 'online tests'

            context 'when credentials are valid' do
              let(:resource) { REST::Resource.new(env_user, env_key) }

              describe '#mail' do
                context 'with required fields' do
                  it 'sends the email' do
                    subject.send(required_options).success?.should be_true
                  end
                end

                context 'without required fields' do
                  it 'raises an error' do
                    expect { subject.send(:to => to) }.to raise_error(REST::Errors::BadRequest)
                  end
                end

                context 'with files attached' do
                  it 'sends the email' do
                    subject.send(required_options.merge(:files => files)).success?.should be_true
                  end
                end

                context 'with SMTP API headers' do
                  it 'sends the email' do
                    subject.send(required_options.merge(:x_smtpapi => x_smtpapi)).success?.should be_true
                  end
                end
              end
            end

            context 'when credentials are invalid' do
              describe '#mail' do
                it 'raises error' do
                  expect { subject.send(required_options) }.to raise_error(REST::Errors::BadRequest)
                end
              end
            end
          end

        end
      end
    end
  end
end