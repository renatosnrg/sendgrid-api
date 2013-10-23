require 'spec_helper'

module Sendgrid
  module API
    module REST
      module Response
        describe ParseJson do

          subject { parse_json }
          let(:parse_json) { described_class.new }

          describe '#parse' do
            context 'body is nil' do
              let(:body) { nil }

              it 'should return nil' do
                subject.parse(body).should be_nil
              end
            end

            context 'body is not a valid JSON' do
              let(:body) { 'some plain text' }

              it 'should raise JSON::ParserError' do
                expect { subject.parse(body) }.to raise_error(JSON::ParserError)
              end
            end

            context 'body is a valid JSON' do
              let(:body) do
                { 'name' => 'my name' }.to_json
              end

              subject { parse_json.parse(body) }

              it { should be_instance_of(Hash) }
              its([:name]) { should == 'my name'}
            end
          end

        end
      end
    end
  end
end
