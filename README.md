# Sendgrid::API

[![Build Status](https://secure.travis-ci.org/renatosnrg/sendgrid-api.png?branch=master)][gem]
[![Code Climate](https://codeclimate.com/github/renatosnrg/sendgrid-api.png)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/renatosnrg/sendgrid-api/badge.png?branch=master)][coveralls]

[gem]: http://travis-ci.org/renatosnrg/sendgrid-api
[codeclimate]: https://codeclimate.com/github/renatosnrg/sendgrid-api
[coveralls]: https://coveralls.io/r/renatosnrg/sendgrid-api

A Ruby interface to the SendGrid API.

## API Coverage

The SendGrid API is being covered on demand. The next APIs to be supported are the complete [Marketing Email API](http://sendgrid.com/docs/API_Reference/Marketing_Emails_API/index.html) and [Mail](http://sendgrid.com/docs/API_Reference/Web_API/mail.html) (Web API).

Check which SendGrid APIs are currently being covered by this gem:
[https://github.com/renatosnrg/sendgrid-api/wiki/SendGrid-API-Coverage][coverage]

[coverage]: https://github.com/renatosnrg/sendgrid-api/wiki/SendGrid-API-Coverage

## Installation

Add this line to your application's Gemfile:

    gem 'sendgrid-api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sendgrid-api

## Configuration

```ruby
client = Sendgrid::API::Client.new('YOUR_USER', 'YOUR_KEY')
```

## Usage Examples

**Get your SendGrid Profile**

```ruby
profile = client.profile.get
```

**Modify your SendGrid Profile**

```ruby
profile = Sendgrid::API::Entities::Profile.new(:first_name => 'Your first name',
                                               :last_name => 'Your last name')
response = client.profile.set(profile)
```

**Get Advanced Statistics**

```ruby
stats = client.stats.advanced(:start_date => '2013-01-01', :data_type => 'global')
```

## Contributing

If you want to contribute to cover more APIs or improve something already implemented, follow these steps:

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes - do not forget tests (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
