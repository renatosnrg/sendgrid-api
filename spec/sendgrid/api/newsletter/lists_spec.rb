require 'spec_helper'

module Sendgrid
  module API
    module Newsletter
      module Lists
        describe Services do

          subject { service }
          let(:service) { described_class.new(resource) }
          let(:resource) { REST::Resource.new(user, key) }
          let(:user) { 'my_user' }
          let(:key) { 'my_key' }
          let(:sg_mock) { Sendgrid::Mock.new(user, key) }

          describe '#add' do
            let(:url) { 'newsletter/lists/add.json' }
            let(:listname) { 'list 1' }
            let(:stub_post) { sg_mock.stub_post(url, :list => listname) }

            subject { service.add(listname) }

            context 'when add a list successfully' do
              context 'with name' do
                it_behaves_like 'a success response'
              end

              context 'with object' do
                let(:list) { Entities::List.new(:list => listname) }
                subject { service.add(list) }
                it_behaves_like 'a success response'
              end
            end

            context 'when permission failed' do
              it_behaves_like 'a forbidden response'
            end

            context 'when list already exists' do
              it_behaves_like 'an already exists response'
            end
          end

          describe '#edit' do
            let(:url) { 'newsletter/lists/edit.json' }
            let(:listname) { 'list 1' }
            let(:newlistname) { 'new list 1' }
            let(:stub_post) { sg_mock.stub_post(url, :list => listname, :newlist => newlistname) }

            subject { service.edit(listname, newlistname) }

            context 'when edit a list successfully' do
              context 'with name' do
                it_behaves_like 'a success response'
              end

              context 'with object' do
                let(:list) { Entities::List.new(:list => listname) }
                let(:newlist) { Entities::List.new(:list => newlistname) }
                subject { service.edit(list, newlist) }
                it_behaves_like 'a success response'
              end
            end

            context 'when permission failed' do
              it_behaves_like 'a forbidden response'
            end

            context 'when list already exists' do
              it_behaves_like 'an already exists response'
            end

            context 'when list does not exist' do
              it_behaves_like 'a does not exist response'
            end
          end

          describe '#delete' do
            let(:url) { 'newsletter/lists/delete.json' }
            let(:listname) { 'list 1' }
            let(:stub_post) { sg_mock.stub_post(url, :list => listname) }

            subject { service.delete(listname) }

            context 'when delete a list successfully' do
              context 'with name' do
                it_behaves_like 'a success response'
              end

              context 'with object' do
                let(:list) { Entities::List.new(:list => listname) }
                subject { service.delete(list) }
                it_behaves_like 'a success response'
              end
            end

            context 'when permission failed' do
              it_behaves_like 'a forbidden response'
            end

            context 'when list does not exist' do
              it_behaves_like 'a does not exist response'
            end
          end

          describe '#get' do
            let(:url) { 'newsletter/lists/get.json' }
            let(:response) { service.get(listname) }
            let(:listname) { 'list 1' }
            let(:stub_post) { sg_mock.stub_post(url, :list => listname) }
            subject { response }

            context 'when get all lists successfully' do
              let(:stub_post) { sg_mock.stub_post(url) }
              let(:response) { service.get }

              before do
                stub_post.to_return(:body => fixture('lists/lists.json'))
              end

              it { should_not be_empty }
              it { should have(3).items }

              describe 'first list' do
                subject { response.first }
                it { should be_instance_of(Entities::List) }
                its(:list) { should == 'list 1' }
              end
            end

            context 'when get a list successfully' do
              before do
                stub_post.to_return(:body => fixture('lists/list.json'))
              end

              context 'with name' do
                it { should_not be_empty }
                it { should have(1).item }
              end

              context 'with object' do
                let(:response) { service.get(list) }
                let(:list) { Entities::List.new(:list => listname) }

                it { should_not be_empty }
                it { should have(1).item }
              end
            end

            context 'when permission failed' do
              it_behaves_like 'a forbidden response'
            end

            context 'when not found' do
              it_behaves_like 'a does not exist response'
            end
          end

          describe 'online tests', :online => true do
            include_examples 'online tests'
            let(:online) { Online.new(env_user, env_key) }
            let(:list) { online.list_example }
            let(:newlistname) { 'sendgrid-api new list test' }

            context 'when credentials are valid' do
              let(:resource) { REST::Resource.new(env_user, env_key) }

              describe '#add' do
                after do
                  subject.delete(list).success? or raise 'could not remove the created list'
                end

                context 'when add a list successfully' do
                  it 'adds a list' do
                    subject.add(list).success?.should be_true
                  end
                end

                context 'when list already exists' do
                  before do
                    subject.add(list).success? or raise 'could not create the list'
                  end
                  it 'raises an error' do
                    expect { subject.add(list) }.to raise_error(REST::Errors::UnprocessableEntity)
                  end
                end
              end

              describe '#edit' do
                context 'when edit a list successfully' do
                  before do
                    subject.add(list).success? or raise 'could not create the list'
                  end
                  after do
                    subject.delete(newlistname).success? or raise 'could not remove the created list'
                  end
                  it 'edits a list' do
                    subject.edit(list, newlistname).success?.should be_true
                  end
                end

                context 'when list does not exist' do
                  before do
                    subject.add(newlistname).success? or raise 'could not create the list'
                  end
                  after do
                    subject.delete(newlistname).success? or raise 'could not remove the created list'
                  end
                  it 'raises an error' do
                    expect { subject.edit(list, newlistname) }.to raise_error(REST::Errors::Unauthorized)
                  end
                end

                context 'when list already exists' do
                  before do
                    subject.add(list).success? or raise 'could not create the list'
                    subject.add(newlistname).success? or raise 'could not create the list'
                  end
                  after do
                    subject.delete(list).success? or raise 'could not remove the created list'
                    subject.delete(newlistname).success? or raise 'could not remove the created list'
                  end
                  it 'raises an error' do
                    expect { subject.edit(list, newlistname) }.to raise_error(REST::Errors::Unauthorized)
                  end
                end
              end

              describe '#delete' do
                context 'when delete a list successfully' do
                  before do
                    subject.add(list).success? or raise 'could not create the list'
                  end
                  it 'deletes a list' do
                    subject.delete(list).success?.should be_true
                  end
                end

                context 'when list does not exist' do
                  it 'raises an error' do
                    expect { subject.delete(list) }.to raise_error(REST::Errors::UnprocessableEntity)
                  end
                end
              end

              describe '#get' do
                context 'when get all lists successfully' do
                  before do
                    subject.add(list).success? or raise 'could not create the list'
                  end
                  after do
                    subject.delete(list).success? or raise 'could not remove the created list'
                  end
                  it 'gets a list' do
                    subject.get.should_not be_empty
                  end
                end

                context 'when get a list successfully' do
                  before do
                    subject.add(list).success? or raise 'could not create the list'
                  end
                  after do
                    subject.delete(list).success? or raise 'could not remove the created list'
                  end
                  it 'gets a list' do
                    subject.get(list).should_not be_empty
                  end
                end

                context 'when list does not exist' do
                  it 'raises an error' do
                    expect { subject.get(list) }.to raise_error(REST::Errors::Unauthorized)
                  end
                end
              end
            end

            context 'when credentials are invalid' do
              describe '#add' do
                it 'raises an error' do
                  expect { subject.add(list) }.to raise_error(REST::Errors::Forbidden)
                end
              end
              describe '#edit' do
                it 'raises an error' do
                  expect { subject.edit(list, newlistname) }.to raise_error(REST::Errors::Forbidden)
                end
              end
              describe '#delete' do
                it 'raises an error' do
                  expect { subject.delete(list) }.to raise_error(REST::Errors::Forbidden)
                end
              end
              describe '#get' do
                it 'raises an error' do
                  expect { subject.get(list) }.to raise_error(REST::Errors::Forbidden)
                end
              end
            end
          end

        end
      end
    end
  end
end