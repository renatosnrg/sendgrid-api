require 'spec_helper'

module Sendgrid
  module API
    module Entities
      describe Profile do
        subject { described_class.new }

        it { should respond_to(:username) }
        it { should respond_to(:email) }
        it { should respond_to(:active) }
        it { should respond_to(:first_name) }
        it { should respond_to(:last_name) }
        it { should respond_to(:address) }
        it { should respond_to(:address2) }
        it { should respond_to(:city) }
        it { should respond_to(:state) }
        it { should respond_to(:zip) }
        it { should respond_to(:country) }
        it { should respond_to(:phone) }
        it { should respond_to(:website) }
        it { should respond_to(:website_access) }
      end
    end
  end
end