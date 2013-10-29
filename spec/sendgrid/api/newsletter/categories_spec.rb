require 'spec_helper'

module Sendgrid
  module API
    module Newsletter
      module Categories
        describe Services do

          subject { service }
          let(:service) { described_class.new(resource) }
          let(:resource) { REST::Resource.new(user, key) }
          let(:user) { 'my_user' }
          let(:key) { 'my_key' }
          let(:sg_mock) { Sendgrid::Mock.new(user, key) }

          describe '#create' do
            let(:url) { 'newsletter/category/create.json' }
            let(:category_name) { 'my category' }
            let(:stub_post) { sg_mock.stub_post(url, :category => category_name) }
            subject { service.create(category_name) }

            context 'when create a category successfully' do
              context 'with name' do
                it_behaves_like 'a success response'
              end

              context 'with objects' do
                let(:category) { Entities::Category.new(:category => category_name) }
                subject { service.create(category) }
                it_behaves_like 'a success response'
              end
            end

            context 'when the category already exists' do
              it_behaves_like 'an already exists unauthorized response'
            end

            context 'when permission failed' do
              it_behaves_like 'a forbidden response'
            end
          end

          describe '#add' do
            let(:url) { 'newsletter/category/add.json' }
            let(:category_name) { 'my category' }
            let(:marketing_email_name) { 'my marketing email' }
            let(:stub_post) { sg_mock.stub_post(url, :name => marketing_email_name, :category => category_name) }
            subject { service.add(marketing_email_name, category_name) }

            context 'when add a category successfully' do
              context 'with name' do
                it_behaves_like 'a success response'
              end

              context 'with objects' do
                let(:category) { Entities::Category.new(:category => category_name) }
                let(:marketing_email) { Entities::MarketingEmail.new(:name => marketing_email_name) }
                subject { service.add(marketing_email, category) }
                it_behaves_like 'a success response'
              end
            end

            context 'when the marketing email does not exist' do
              it_behaves_like 'a does not exist response'
            end

            context 'when permission failed' do
              it_behaves_like 'a forbidden response'
            end
          end

          describe '#remove' do
            let(:url) { 'newsletter/category/remove.json' }
            let(:category_name) { 'my category' }
            let(:marketing_email_name) { 'my marketing email' }
            let(:stub_post) { sg_mock.stub_post(url, :name => marketing_email_name, :category => category_name) }
            subject { service.remove(marketing_email_name, category_name) }

            context 'when remove a category successfully' do
              context 'with name' do
                it_behaves_like 'a success response'
              end

              context 'with objects' do
                let(:category) { Entities::Category.new(:category => category_name) }
                let(:marketing_email) { Entities::MarketingEmail.new(:name => marketing_email_name) }
                subject { service.remove(marketing_email, category) }
                it_behaves_like 'a success response'
              end
            end

            context 'when the category does not exist' do
              it_behaves_like 'a does not exist response'
            end

            context 'when the marketing email does not exist' do
              it_behaves_like 'a does not exist response'
            end

            context 'when permission failed' do
              it_behaves_like 'a forbidden response'
            end
          end

          describe '#list' do
            let(:url) { 'newsletter/category/list.json' }
            let(:stub_post) { sg_mock.stub_post(url) }
            subject { service.list }

            context 'when list all categories successfully' do
              before do
                stub_post.to_return(:body => fixture('categories.json'))
              end

              it { should have(3).items }

              describe 'first item' do
                subject { service.list.first }
                its(:category) { should == 'sendgrid' }
              end
            end

            context 'when permission failed' do
              it_behaves_like 'a forbidden response'
            end
          end

          describe 'online tests', :online => true do
            include_examples 'online tests'
            let(:online) { Online.new(env_user, env_key) }
            let(:category) { online.category_example }
            let(:marketing_email) { online.marketing_email_example }

            context 'when credentials are valid' do
              before do
                # try to create the test category
                # note: categories can't be removed for now
                begin
                  subject.create(category)
                rescue REST::Errors::Unauthorized
                  # it already exists, do nothing
                end
              end
              let(:resource) { REST::Resource.new(env_user, env_key) }

              describe '#create' do
                context 'when the category already exists' do
                  it 'raises an error' do
                    expect { subject.create(category) }.to raise_error(REST::Errors::Unauthorized)
                  end
                end
              end

              describe '#add' do
                context 'when add a category successfully' do
                  before do
                    online.add_marketing_email
                  end
                  after do
                    online.delete_marketing_email
                  end
                  it 'adds the category' do
                    subject.add(marketing_email, category).success?.should be_true
                  end
                end

                context 'when the marketing email does not exist' do
                  it 'raises an error' do
                    expect { subject.add(marketing_email, category) }.to raise_error(REST::Errors::Unauthorized)
                  end
                end
              end

              describe '#remove' do
                context 'when remove a category successfully' do
                  before do
                    online.add_marketing_email
                    subject.add(marketing_email, category)
                  end
                  after do
                    online.delete_marketing_email
                  end
                  it 'removes the category' do
                    subject.remove(marketing_email, category).success?.should be_true
                  end
                end

                context 'when the marketing email does not exist' do
                  it 'raises an error' do
                    expect { subject.remove(marketing_email, category) }.to raise_error(REST::Errors::Unauthorized)
                  end
                end

                context 'when the category does not exist' do
                  before do
                    online.add_marketing_email
                  end
                  after do
                    online.delete_marketing_email
                  end
                  it 'raises an error' do
                    expect { subject.remove(marketing_email, category) }.to raise_error(REST::Errors::Unauthorized)
                  end
                end
              end

              describe '#list' do
                context 'when list all categories successfully' do
                  it 'get all categories' do
                    subject.list.should_not be_empty
                  end
                end
              end
            end

            context 'when credentials are invalid' do
              describe '#create' do
                it 'raises an error' do
                  expect { subject.create(category) }.to raise_error(REST::Errors::Forbidden)
                end
              end

              describe '#add' do
                it 'raises an error' do
                  expect { subject.add(marketing_email, category) }.to raise_error(REST::Errors::Forbidden)
                end
              end

              describe '#remove' do
                it 'raises an error' do
                  expect { subject.remove(marketing_email, category) }.to raise_error(REST::Errors::Forbidden)
                end
              end

              describe '#list' do
                it 'raises an error' do
                  expect { subject.list }.to raise_error(REST::Errors::Forbidden)
                end
              end
            end
          end

        end
      end
    end
  end
end