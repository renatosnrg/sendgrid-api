require 'spec_helper'

module Sendgrid
  module API
    describe Client do

      subject { described_class.new(user, key) }
      let(:user) { 'some user' }
      let(:key) { 'some key' }

      its(:user) { should == user }
      its(:key) { should == key }

      it { should respond_to(:profile) }
      it { should respond_to(:stats) }
      it { should respond_to(:lists) }
      it { should respond_to(:emails) }

      its(:profile) { should_not be_nil }
      its(:stats) { should_not be_nil }
      its(:lists) { should_not be_nil }
      its(:emails) { should_not be_nil }

    end
  end
end
