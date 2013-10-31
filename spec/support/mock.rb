module Sendgrid
  class Mock
    include WebMock::API

    def initialize(user, key)
      @user = user
      @key = key
    end

    def stub_post(path, params = {})
      stub_request(:post, uri(path)).
        with(:body => params.merge(authentication_params))
    end

    def a_post(path, params = {})
      a_request(:post, uri(path)).
        with(:body => params.merge(authentication_params))
    end

    def uri(path)
      Sendgrid::API::REST::Resource::ENDPOINT + '/' + path
    end

    private

    def authentication_params
      { :api_key => @key, :api_user => @user }
    end
  end
end