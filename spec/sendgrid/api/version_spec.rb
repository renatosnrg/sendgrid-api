require 'spec_helper'

module Sendgrid
  describe API do

    it 'has a non-null VERSION constant' do
      API::VERSION.should_not be_nil
    end

  end
end
