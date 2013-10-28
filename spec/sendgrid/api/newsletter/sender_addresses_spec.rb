require 'spec_helper'

module Sendgrid
  module API
    module Newsletter
      module SenderAddresses
        describe Services do

          subject { service }
          let(:service) { described_class.new(resource) }
          let(:resource) { REST::Resource.new(user, key) }
          let(:user) { 'my_user' }
          let(:key) { 'my_key' }
          let(:sg_mock) { Sendgrid::Mock.new(user, key) }

          let(:sender_address) { Entities::SenderAddress.new(:identity => identity, :email => email) }
          let(:identity) { 'my sender address' }
          let(:email) { 'john@example.com' }

          describe '#add' do
            let(:url) { 'newsletter/identity/add.json' }
            let(:stub_post) { sg_mock.stub_post(url, sender_address.as_json) }
            subject { service.add(sender_address) }

            context 'when add a sender address successfully' do
              it_behaves_like 'a success response'
            end

            context 'when the sender address already exists' do
              it_behaves_like 'an unauthorized response'
            end

            context 'when the sender address is invalid' do
              it_behaves_like 'an invalid fields response'
            end

            context 'when permission failed' do
              it_behaves_like 'a forbidden response'
            end
          end

          describe '#edit' do
            let(:url) { 'newsletter/identity/edit.json' }
            let(:stub_post) { sg_mock.stub_post(url, sender_address.as_json) }
            subject { service.edit(sender_address) }

            context 'when edit a sender address successfully' do
              it_behaves_like 'a success response'
            end

            context 'when edit the sender address identity successfully' do
              let(:stub_post) { sg_mock.stub_post(url, sender_address.as_json.merge(:newidentity => new_identity)) }
              let(:new_identity) { 'my new sender address' }
              subject { service.edit(sender_address, new_identity) }
              it_behaves_like 'a success response'
            end

            context 'when the sender address is invalid' do
              it_behaves_like 'a does not exist response'
            end

            context 'when permission failed' do
              it_behaves_like 'a forbidden response'
            end
          end

          describe '#get' do
            let(:url) { 'newsletter/identity/get.json' }
            let(:stub_post) { sg_mock.stub_post(url, :identity => identity) }
            subject { service.get(sender_address) }

            context 'when get the sender address successfully' do
              context 'with name' do
                before do
                  stub_post.to_return(:body => fixture('sender_addresses/sender_address.json'))
                end
                subject { service.get(identity) }
                its(:identity) { should == 'sendgrid' }
              end

              context 'with object' do
                before do
                  stub_post.to_return(:body => fixture('sender_addresses/sender_address.json'))
                end
                its(:identity) { should == 'sendgrid' }
              end
            end

            context 'when the sender address is not found' do
              before do
                stub_post.to_return(:body => fixture('errors/does_not_exist.json'), :status => 401)
              end

              it 'raises an error' do
                expect { subject }.to raise_error(REST::Errors::Unauthorized)
              end
            end

            context 'when permission failed' do
              it_behaves_like 'a forbidden response'
            end
          end

          describe '#list' do
            let(:url) { 'newsletter/identity/list.json' }
            let(:stub_post) { sg_mock.stub_post(url) }
            subject { service.list }

            context 'when list sender addresses successfully' do
              before do
                stub_post.to_return(:body => fixture('sender_addresses/sender_addresses.json'))
              end
              it { should have(3).items }
              describe 'first item' do
                subject { service.list.first }
                its(:identity) { should == 'sendgrid' }
              end
            end

            context 'when permission failed' do
              it_behaves_like 'a forbidden response'
            end
          end

          describe '#delete' do
            let(:url) { 'newsletter/identity/delete.json' }
            let(:stub_post) { sg_mock.stub_post(url, :identity => identity) }
            subject { service.delete(sender_address) }

            context 'when delete the sender address successfully' do
              it_behaves_like 'a success response'
            end

            context 'when the sender address is not found' do
              it_behaves_like 'a does not exist response'
            end

            context 'when permission failed' do
              it_behaves_like 'a forbidden response'
            end
          end

          describe 'online tests', :online => true do
            include_examples 'online tests'
            let(:sender_address) do
              Entities::SenderAddress.new(:identity => identity,
                                          :name => name,
                                          :email => email,
                                          :address => address,
                                          :city => city,
                                          :state => state,
                                          :zip => zip,
                                          :country => country)
            end
            let(:identity) { 'sendgrid-api sender address test' }
            let(:name) { 'Sendgrid' }
            let(:email) { 'contact@sendgrid.com' }
            let(:address) { '1065 N Pacificenter Drive, Suite 425' }
            let(:city) { 'Anaheim' }
            let(:state) { 'CA' }
            let(:zip) { '92806' }
            let(:country) { 'US' }

            context 'when credentials are valid' do
              let(:resource) { REST::Resource.new(env_user, env_key) }

              describe '#add' do
                context 'when add a sender address successfully' do
                  after do
                    subject.delete(sender_address)
                  end
                  it 'adds the sender address' do
                    subject.add(sender_address).success?.should be_true
                  end
                end

                context 'when the sender address already exists' do
                  before do
                    subject.add(sender_address)
                  end
                  after do
                    subject.delete(sender_address)
                  end
                  it 'raises an error' do
                    expect { subject.add(sender_address) }.to raise_error(Sendgrid::API::REST::Errors::Unauthorized)
                  end
                end

                context 'when the sender address is invalid' do
                  let(:email) { nil }
                  it 'raises an error' do
                    expect { subject.add(sender_address) }.to raise_error(Sendgrid::API::REST::Errors::BadRequest)
                  end
                end
              end

              describe '#edit' do
                context 'when edit a sender address successfully' do
                  let(:address) { 'new address' }
                  before do
                    subject.add(sender_address)
                  end
                  after do
                    subject.delete(sender_address)
                  end
                  it 'edits the sender address' do
                    subject.edit(sender_address).success?.should be_true
                  end
                end

                context 'when edit the sender address identity successfully' do
                  let(:newidentity) { 'sendgrid-api sender address new' }
                  before do
                    subject.add(sender_address)
                  end
                  after do
                    subject.delete(newidentity)
                  end
                  it 'edits the sender address' do
                    subject.edit(sender_address, newidentity).success?.should be_true
                  end
                end

                context 'when the sender address is invalid' do
                  it 'raises an error' do
                    expect { subject.edit(sender_address) }.to raise_error(Sendgrid::API::REST::Errors::Unauthorized)
                  end
                end
              end

              describe '#get' do
                context 'when get the sender address successfully' do
                  before do
                    subject.add(sender_address)
                  end
                  after do
                    subject.delete(sender_address)
                  end
                  it 'edits the sender address' do
                    sender = subject.get(sender_address)
                    sender.name.should == name
                    sender.address.should == address
                  end
                end

                context 'when the sender address is not found' do
                  it 'raises an error' do
                    expect { subject.edit(sender_address) }.to raise_error(Sendgrid::API::REST::Errors::Unauthorized)
                  end
                end
              end

              describe '#list' do
                context 'when list sender addresses successfully' do
                  it 'gets all the sender addresses' do
                    subject.list.should_not be_empty
                  end
                end
              end

              describe '#delete' do
                context 'when delete the sender address successfully' do
                  before do
                    subject.add(sender_address)
                  end
                  it 'deletes the sender address' do
                    subject.delete(sender_address).success?.should be_true
                  end
                end

                context 'when the sender address is not found' do
                  it 'raises an error' do
                    expect { subject.delete(sender_address) }.to raise_error(Sendgrid::API::REST::Errors::Unauthorized)
                  end
                end
              end
            end

            context 'when credentials are invalid' do
              describe '#add' do
                it 'raises an error' do
                  expect { subject.add(sender_address) }.to raise_error(REST::Errors::Forbidden)
                end
              end

              describe '#edit' do
                it 'raises an error' do
                  expect { subject.edit(sender_address) }.to raise_error(REST::Errors::Forbidden)
                end
              end

              describe '#get' do
                it 'raises an error' do
                  expect { subject.get(sender_address) }.to raise_error(REST::Errors::Forbidden)
                end
              end

              describe '#list' do
                it 'raises an error' do
                  expect { subject.list }.to raise_error(REST::Errors::Forbidden)
                end
              end

              describe '#delete' do
                it 'raises an error' do
                  expect { subject.delete(sender_address) }.to raise_error(REST::Errors::Forbidden)
                end
              end
            end
          end

        end
      end
    end
  end
end
