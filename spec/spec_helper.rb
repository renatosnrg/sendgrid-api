require 'simplecov'
require 'coveralls'

SimpleCov.formatters = [
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

Dir["./spec/support/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|
  config.filter_run_excluding :online => true unless ENV['ALL']
end

disable_http