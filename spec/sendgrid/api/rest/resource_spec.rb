require 'spec_helper'

module Sendgrid
  module API
    module REST
      describe Resource do
        subject { resource }
        let(:resource) { described_class.new(user, key) }
        let(:user) { 'my_user' }
        let(:key) { 'my_key' }

        its(:user) { should == user }
        its(:key) { should == key }

        it 'should have a valid ENDPOINT' do
          described_class::ENDPOINT.should == 'https://sendgrid.com/api'
        end

        describe '#post' do
          let(:url) { 'any_path' }
          let(:response) { double('response') }

          context 'without params' do
            before do
              subject.should_receive(:request).with(:post, url, {}).and_return(response)
            end

            it 'should perform the request' do
              subject.post(url).should == response
            end
          end

          context 'with params' do
            before do
              subject.should_receive(:request).with(:post, url, params).and_return(response)
            end
            let(:params) { {:name => 'my name'} }

            it 'should perform the request' do
              subject.post(url, params).should == response
            end
          end
        end

        describe '#request' do
          let(:url) { 'any_path' }
          let(:sg_mock) { Sendgrid::Mock.new(user, key) }

          context 'without params' do
            before do
              sg_mock.stub_post(url)
            end

            it 'should perform a request' do
              subject.send(:request, :post, url)
              sg_mock.a_post(url).should have_been_made
            end
          end

          context 'with params' do
            before do
              sg_mock.stub_post(url, params)
            end
            let(:params) { {:name => 'my name'} }

            it 'should perform a request' do
              subject.send(:request, :post, url, params)
              sg_mock.a_post(url, params).should have_been_made
            end
          end

          context 'catches the errors' do
            it 'catches Faraday errors' do
              subject.stub(:connection).and_raise(Faraday::Error::ClientError.new('unknown error'))
              expect { subject.send(:request, :post, url) }.to raise_error Sendgrid::API::REST::Errors::Unknown
            end

            it 'catches JSON::ParserError errors' do
              subject.stub(:connection).and_raise(JSON::ParserError.new('unexpected token"'))
              expect { subject.send(:request, :post, url) }.to raise_error Sendgrid::API::REST::Errors::Unknown
            end

            it 'catches status errors' do
              sg_mock.stub_post(url).to_return(:status => 400)
              expect { subject.send(:request, :post, url) }.to raise_error Sendgrid::API::REST::Errors::BadRequest
            end

            it 'catches body errors' do
              sg_mock.stub_post(url).to_return(:body => {:error => {:code => 401}}.to_json)
              expect { subject.send(:request, :post, url) }.to raise_error Sendgrid::API::REST::Errors::Unauthorized
            end
          end

          context 'parses body as JSON' do
            before do
              sg_mock.stub_post(url).to_return(:body => {'name' => 'my name'}.to_json)
            end

            subject { resource.send(:request, :post, url).body }

            it { should be_instance_of(Hash) }
            its([:name]) { should == 'my name'}
          end
        end

        describe '#middleware' do
          it 'should be a valid Faraday middleware' do
            subject.send(:middleware).should be_instance_of(Faraday::Builder)
          end

          it 'should memoize the middleware' do
            middleware = double('middleware')
            Faraday::Builder.should_receive(:new).once.and_return(middleware)

            subject.send(:middleware).should == middleware
            subject.send(:middleware).should == middleware
          end
        end

        describe '#connection' do
          it 'should be a valid Faraday connection' do
            subject.send(:connection).should be_instance_of(Faraday::Connection)
          end

          it 'should memoize the connection' do
            connection = double('connection')
            Faraday.should_receive(:new).once.and_return(connection)

            subject.send(:connection).should == connection
            subject.send(:connection).should == connection
          end
        end

        describe '#authentication_params' do
          subject { resource.send(:authentication_params) }

          its([:api_user]) { should == user }
          its([:api_key]) { should == key }
        end
      end
    end
  end
end