require 'spec_helper'

module Sendgrid
  module API
    module Web
      module Profile
        describe Services do

          subject { service }
          let(:service) { described_class.new(resource) }
          let(:resource) { REST::Resource.new(user, key) }
          let(:user) { 'my_user' }
          let(:key) { 'my_key' }
          let(:sg_mock) { Sendgrid::Mock.new(user, key) }

          describe '#get' do
            let(:url) { 'profile.get.json' }
            let(:stub_post) { sg_mock.stub_post(url) }
            subject { service.get }

            context 'when request is successfull' do
              before do
                stub_post.to_return(:body => fixture('profile.json'))
              end

              it 'performs the request' do
                subject
                sg_mock.a_post(url).should have_been_made
              end

              it { should be_instance_of Entities::Profile }

              its(:username) { should == 'sendgrid' }
              its(:email) { should == 'contact@sendgrid.com' }
              its(:active) { should == 'true' }
              its(:first_name) { should == 'Jim' }
              its(:last_name) { should == 'Franklin' }
              its(:address) { should == '1065 N Pacificenter Drive, Suite 425' }
              its(:address2) { should == '' }
              its(:city) { should == 'Anaheim' }
              its(:state) { should == 'CA' }
              its(:zip) { should == '92806' }
              its(:country) { should == 'US' }
              its(:phone) { should == '123456789' }
              its(:website) { should == 'http://www.sendgrid.com' }
              its(:website_access) { should == 'true' }
            end

            context 'when permission failed' do
              it_behaves_like 'an unauthorized response'
            end
          end

          describe '#set' do
            let(:url) { 'profile.set.json' }
            let(:profile) { Entities::Profile.new(:first_name => 'Brian', :last_name => 'O\'Neill') }
            let(:stub_post) { sg_mock.stub_post(url, profile.as_json) }
            subject { service.set(profile) }

            context 'when request is successfull' do
              it_behaves_like 'a success response'
            end

            context 'when permission failed' do
              it_behaves_like 'an unauthorized response'
            end
          end

          describe 'online tests', :online => true do
            include_examples 'online tests'

            context 'when credentials are valid' do
              let(:resource) { REST::Resource.new(env_user, env_key) }

              describe '#get' do
                it 'gets profile' do
                  subject.get.should be_instance_of(Entities::Profile)
                end
              end

              describe '#set' do
                it 'updates profile' do
                  profile = subject.get
                  subject.set(profile).success?.should be_true
                end
              end
            end

            context 'when credentials are invalid' do
              describe '#get' do
                it 'raises error' do
                  expect { subject.get }.to raise_error(REST::Errors::Unauthorized)
                end
              end

              describe '#set' do
                let(:profile) { Entities::Profile.new(:first_name => 'Brian', :last_name => 'O\'Neill') }

                it 'raises error' do
                  expect { subject.set(profile) }.to raise_error(REST::Errors::Unauthorized)
                end
              end
            end
          end

        end
      end
    end
  end
end