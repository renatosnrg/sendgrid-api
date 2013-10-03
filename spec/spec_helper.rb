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

RSpec.configure do |config|
end
