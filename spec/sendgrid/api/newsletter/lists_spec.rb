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
              before do
                stub_post.to_return(:body => fixture('success.json'))
              end

              context 'with name' do
                its(:success?) { should be_true }
              end

              context 'with object' do
                let(:list) { Entities::List.new(:list => listname) }
                subject { service.add(list) }
                its(:success?) { should be_true }
              end
            end

            context 'when permission failed' do
              before do
                stub_post.to_return(:body => fixture('errors/forbidden.json'), :status => 403)
              end

              it 'raises an error' do
                expect { subject }.to raise_error(REST::Errors::Forbidden)
              end
            end

            context 'when list already exists' do
              before do
                stub_post.to_return(:body => fixture('errors/already_exists.json'))
              end

              it 'raises an error' do
                expect { subject }.to raise_error(REST::Errors::UnprocessableEntity)
              end
            end
          end

          describe '#edit' do
            let(:url) { 'newsletter/lists/edit.json' }
            let(:listname) { 'list 1' }
            let(:newlistname) { 'new list 1' }
            let(:stub_post) { sg_mock.stub_post(url, :list => listname, :newlist => newlistname) }

            subject { service.edit(listname, newlistname) }

            context 'when edit a list successfully' do
              before do
                stub_post.to_return(:body => fixture('success.json'))
              end

              context 'with name' do
                its(:success?) { should be_true }
              end

              context 'with object' do
                let(:list) { Entities::List.new(:list => listname) }
                let(:newlist) { Entities::List.new(:list => newlistname) }
                subject { service.edit(list, newlist) }
                its(:success?) { should be_true }
              end
            end

            context 'when permission failed' do
              before do
                stub_post.to_return(:body => fixture('errors/forbidden.json'), :status => 403)
              end

              it 'raises an error' do
                expect { subject }.to raise_error(REST::Errors::Forbidden)
              end
            end

            context 'when list already exists' do
              before do
                stub_post.to_return(:body => fixture('errors/already_exists.json'), :status => 401)
              end

              it 'raises an error' do
                expect { subject }.to raise_error(REST::Errors::Unauthorized)
              end
            end

            context 'when list does not exist' do
              before do
                stub_post.to_return(:body => fixture('errors/does_not_exist.json'), :status => 401)
              end

              it 'raises an error' do
                expect { subject }.to raise_error(REST::Errors::Unauthorized)
              end
            end
          end

          describe '#delete' do
            let(:url) { 'newsletter/lists/delete.json' }
            let(:listname) { 'list 1' }
            let(:stub_post) { sg_mock.stub_post(url, :list => listname) }

            subject { service.delete(listname) }

            context 'when delete a list successfully' do
              before do
                stub_post.to_return(:body => fixture('success.json'))
              end

              context 'with name' do
                its(:success?) { should be_true }
              end

              context 'with object' do
                let(:list) { Entities::List.new(:list => listname) }
                subject { service.delete(list) }
                its(:success?) { should be_true }
              end
            end

            context 'when permission failed' do
              before do
                stub_post.to_return(:body => fixture('errors/forbidden.json'), :status => 403)
              end

              it 'raises an error' do
                expect { subject }.to raise_error(REST::Errors::Forbidden)
              end
            end

            context 'when list does not exist' do
              before do
                stub_post.to_return(:body => fixture('errors/does_not_exist.json'))
              end

              it 'raises an error' do
                expect { subject }.to raise_error(REST::Errors::UnprocessableEntity)
              end
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
              before do
                stub_post.to_return(:body => fixture('errors/forbidden.json'), :status => 403)
              end

              it 'raises an error' do
                expect { subject }.to raise_error(REST::Errors::Forbidden)
              end
            end

            context 'when not found' do
              before do
                stub_post.to_return(:body => fixture('lists/list_not_found.json'), :status => 401)
              end

              it 'raises an error' do
                expect { subject }.to raise_error(REST::Errors::Unauthorized)
              end
            end
          end

          describe 'online tests', :online => true do
            include_examples 'online tests'
            let(:listname) { 'sendgrid-api list test' }
            let(:newlistname) { 'sendgrid-api new list test' }

            context 'when credentials are valid' do
              let(:resource) { REST::Resource.new(env_user, env_key) }

              describe '#add' do
                after do
                  subject.delete(listname).success? or raise 'could not remove the created list'
                end

                context 'when add a list successfully' do
                  it 'adds a list' do
                    subject.add(listname).success?.should be_true
                  end
                end

                context 'when list already exists' do
                  before do
                    subject.add(listname).success? or raise 'could not create the list'
                  end
                  it 'raises an error' do
                    expect { subject.add(listname) }.to raise_error(REST::Errors::UnprocessableEntity)
                  end
                end
              end

              describe '#edit' do
                context 'when edit a list successfully' do
                  before do
                    subject.add(listname).success? or raise 'could not create the list'
                  end
                  after do
                    subject.delete(newlistname).success? or raise 'could not remove the created list'
                  end
                  it 'edits a list' do
                    subject.edit(listname, newlistname).success?.should be_true
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
                    expect { subject.edit(listname, newlistname) }.to raise_error(REST::Errors::Unauthorized)
                  end
                end

                context 'when list already exists' do
                  before do
                    subject.add(listname).success? or raise 'could not create the list'
                    subject.add(newlistname).success? or raise 'could not create the list'
                  end
                  after do
                    subject.delete(listname).success? or raise 'could not remove the created list'
                    subject.delete(newlistname).success? or raise 'could not remove the created list'
                  end
                  it 'raises an error' do
                    expect { subject.edit(listname, newlistname) }.to raise_error(REST::Errors::Unauthorized)
                  end
                end
              end

              describe '#delete' do
                context 'when delete a list successfully' do
                  before do
                    subject.add(listname).success? or raise 'could not create the list'
                  end
                  it 'deletes a list' do
                    subject.delete(listname).success?.should be_true
                  end
                end

                context 'when list does not exist' do
                  it 'raises an error' do
                    expect { subject.delete(listname) }.to raise_error(REST::Errors::UnprocessableEntity)
                  end
                end
              end

              describe '#get' do
                context 'when get all lists successfully' do
                  before do
                    subject.add(listname).success? or raise 'could not create the list'
                  end
                  after do
                    subject.delete(listname).success? or raise 'could not remove the created list'
                  end
                  it 'gets a list' do
                    subject.get.should_not be_empty
                  end
                end

                context 'when get a list successfully' do
                  before do
                    subject.add(listname).success? or raise 'could not create the list'
                  end
                  after do
                    subject.delete(listname).success? or raise 'could not remove the created list'
                  end
                  it 'gets a list' do
                    subject.get(listname).should_not be_empty
                  end
                end

                context 'when list does not exist' do
                  it 'raises an error' do
                    expect { subject.get(listname) }.to raise_error(REST::Errors::Unauthorized)
                  end
                end
              end
            end

            context 'when credentials are invalid' do
              describe '#add' do
                it 'raises an error' do
                  expect { subject.add(listname) }.to raise_error(REST::Errors::Forbidden)
                end
              end
              describe '#edit' do
                it 'raises an error' do
                  expect { subject.edit(listname, newlistname) }.to raise_error(REST::Errors::Forbidden)
                end
              end
              describe '#delete' do
                it 'raises an error' do
                  expect { subject.delete(listname) }.to raise_error(REST::Errors::Forbidden)
                end
              end
              describe '#get' do
                it 'raises an error' do
                  expect { subject.get(listname) }.to raise_error(REST::Errors::Forbidden)
                end
              end
            end
          end

        end
      end
    end
  end
end