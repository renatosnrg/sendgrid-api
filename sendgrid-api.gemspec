# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sendgrid/api/version'

Gem::Specification.new do |spec|
  spec.name          = "sendgrid-api"
  spec.version       = Sendgrid::Api::VERSION
  spec.authors       = ["Renato Neves"]
  spec.email         = ["renatosnrg@gmail.com"]
  spec.description   = %q{A Ruby interface to the SendGrid API}
  spec.summary       = %q{A Ruby interface to the SendGrid API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
end
