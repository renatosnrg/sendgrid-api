require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  add_filter "/vendor/"
  add_filter "/spec/"
end

require 'sendgrid/api'
require 'rspec'
require 'webmock/rspec'

WebMock.disable_net_connect!(:allow => 'coveralls.io')

RSpec.configure do |config|
end

module Sendgrid
  class Mock
    include WebMock::API

    def initialize(user, key)
      @user = user
      @key = key
    end

    def stub_post(path, params = {})
      stub_request(:post, Sendgrid::API::REST::Resource::ENDPOINT + '/' + path).
        with(:body => params.merge(authentication_params))
    end

    def a_post(path, params = {})
      a_request(:post, Sendgrid::API::REST::Resource::ENDPOINT + '/' + path).
        with(:body => params.merge(authentication_params))
    end

    private

    def authentication_params
      { :api_key => @key, :api_user => @user }
    end
  end
end

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end
