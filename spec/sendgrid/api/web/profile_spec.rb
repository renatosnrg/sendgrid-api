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

            context 'when request is successfull' do
              before do
                sg_mock.stub_post(url).to_return(:body => fixture('profile.json'))
              end

              subject { service.get }

              it 'should perform the request' do
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
              before do
                sg_mock.stub_post(url).to_return(:body => fixture('unauthorized.json'))
              end

              it 'should raise error' do
                expect { service.get }.to raise_error(REST::Errors::Unauthorized)
              end
            end
          end

          describe '#set' do
            let(:url) { 'profile.set.json' }
            let(:profile) { Entities::Profile.new(:first_name => 'Brian', :last_name => 'O\'Neill') }

            context 'when request is successfull' do
              before do
                sg_mock.stub_post(url, profile.as_json).to_return(:body => fixture('success.json'))
              end

              subject { service.set(profile) }

              its(:success?) { should be_true }
            end

            context 'when permission failed' do
              before do
                sg_mock.stub_post(url, profile.as_json).to_return(:body => fixture('unauthorized.json'))
              end

              it 'should raise error' do
                expect { service.set(profile) }.to raise_error(REST::Errors::Unauthorized)
              end
            end
          end

          describe 'online tests', :online => true do
            include_examples 'online tests'

            context 'when credentials are valid' do
              let(:resource) { REST::Resource.new(env_user, env_key) }

              describe '#get' do
                it 'should get profile' do
                  subject.get.should be_instance_of(Entities::Profile)
                end
              end

              describe '#set' do
                it 'should update profile' do
                  profile = subject.get
                  subject.set(profile).success?.should be_true
                end
              end
            end

            context 'when credentials are invalid' do
              describe '#get' do
                it 'should raise error' do
                  expect { subject.get }.to raise_error(REST::Errors::Unauthorized)
                end
              end

              describe '#set' do
                let(:profile) { Entities::Profile.new(:first_name => 'Brian', :last_name => 'O\'Neill') }

                it 'should raise error' do
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