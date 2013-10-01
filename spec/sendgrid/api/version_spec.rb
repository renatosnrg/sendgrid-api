require 'spec_helper'

module Sendgrid
  describe Api do

    it 'has a non-null VERSION constant' do
      Api::VERSION.should_not be_nil
    end

  end
end
