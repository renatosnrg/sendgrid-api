# Sendgrid::API

[![Build Status](https://secure.travis-ci.org/renatosnrg/sendgrid-api.png?branch=master)][gem]
[![Code Climate](https://codeclimate.com/github/renatosnrg/sendgrid-api.png)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/renatosnrg/sendgrid-api/badge.png?branch=master)][coveralls]

[gem]: http://travis-ci.org/renatosnrg/sendgrid-api
[codeclimate]: https://codeclimate.com/github/renatosnrg/sendgrid-api
[coveralls]: https://coveralls.io/r/renatosnrg/sendgrid-api

A Ruby interface to the SendGrid API.

## API Coverage

Check which SendGrid APIs are currently being covered by this gem:

[https://github.com/renatosnrg/sendgrid-api/wiki/SendGrid-API-Coverage][coverage]

[coverage]: https://github.com/renatosnrg/sendgrid-api/wiki/SendGrid-API-Coverage

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sendgrid-api'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install sendgrid-api
```

## Configuration

```ruby
client = Sendgrid::API::Client.new('YOUR_USER', 'YOUR_KEY')
```

## Web API

### Profile

```ruby
# create a profile object
profile = Sendgrid::API::Entities::Profile.new(:first_name => 'Your first name',
                                               :last_name => 'Your last name')
# get your profile
profile = client.profile.get
# modify your profile
response = client.profile.set(profile)
```

### Mail

```ruby
# send basic text email
response = client.mail.send(:to => 'johndoe@example.com',
                            :from => 'brian@example.com',
                            :subject => 'test using sendgrid api',
                            :text => 'this is a test')
# set SMTP API headers
x_smtpapi = {:category => ['sendgrid-api test']}
response = client.mail.send(:to => 'johndoe@example.com',
                            :from => 'brian@example.com',
                            :subject => 'test using sendgrid api',
                            :text => 'this is a test',
                            :x_smtpapi => x_smtpapi)
# send files attached
text = StringIO.new("This is my file content")
file = Faraday::UploadIO.new(text, 'plain/text', 'sample.txt')
response = client.mail.send(:to => 'johndoe@example.com',
                            :from => 'brian@example.com',
                            :subject => 'test using sendgrid api',
                            :text => 'this is a test',
                            :files => {'sample.txt' => file})
```

### Statistics

```ruby
# get advanced statistics
stats = client.stats.advanced(:start_date => '2013-01-01', :data_type => 'global')
```

## Marketing Email API

### Lists

```ruby
# create a list object
list = Sendgrid::API::Entities::List.new(:list => 'sendgrid-api list test')
# add a new list
response = client.lists.add(list)
# edit an existing list
response = client.lists.edit(list, 'new name')
# get an existing list
selected_list = client.lists.get(list)
# get all lists
all_lists = client.lists.get
# delete a list
response = client.lists.delete(list)
```

### Emails

```ruby
# create email objects
email1 = Sendgrid::API::Entities::Email.new(:email => 'johndoe@example.com', :name => 'John Doe')
email2 = Sendgrid::API::Entities::Email.new(:email => 'brian@example.com', :name => 'Brian')
emails = [email1, email2]
listname = 'sendgrid-api list test'
# add emails to a list
response = client.emails.add(listname, emails)
# get all emails from a list
all_emails = client.emails.get(listname)
# get a specific email from a list
selected_emails = client.emails.get(listname, email1)
# delete an email from a list
response = client.emails.delete(listname, email1)
```

### Sender Adresses

```ruby
# create sender address object
address = Sendgrid::API::Entities::SenderAddress.new(
            :identity => 'sendgrid-api sender address test',
            :name     => 'Sendgrid',
            :email    => 'contact@sendgrid.com',
            :address  => '1065 N Pacificenter Drive, Suite 425',
            :city     => 'Anaheim',
            :state    => 'CA',
            :zip      => '92806',
            :country  => 'US'
          )
# add a sender address
response = client.sender_addresses.add(address)
# edit a sender address
address.city = 'Pleasanton'
response = client.sender_addresses.edit(address, 'new identity')
# get all sender addresses
addresses = client.sender_addresses.list
# get a sender address
address = client.sender_addresses.get(address)
# delete a sender address
response = client.sender_addresses.delete(address)
```

### Marketing Emails

```ruby
# create marketing email object
marketing_email = Sendgrid::API::Entities::MarketingEmail.new(
                    :identity => 'sendgrid-api sender address test',
                    :name     => 'sendgrid-api marketing email test',
                    :subject  => 'My Marketing Email Test',
                    :text     => 'My text',
                    :html     => 'My HTML'
                  )
# add a marketing email
response = client.marketing_emails.add(marketing_email)
# edit a marketing email
marketing_email.html = 'My new HTML'
response = client.marketing_emails.edit(marketing_email, 'new name')
# get a marketing email
newsletter = client.marketing_emails.get(marketing_email)
# get all marketing emails
newsletters = client.marketing_emails.list
# delete a marketing email
response = client.marketing_emails.delete(marketing_email)
```

### Categories

```ruby
# create category object
category = Sendgrid::API::Entities::Category.new(:category => 'sendgrid-api test')
marketing_email = 'sendgrid-api marketing email test'
# add category
response = client.categories.create(category)
# add category to a marketing email
response = client.categories.add(marketing_email, category)
# remove category from a marketing email
response = client.categories.remove(marketing_email, category)
# get all categories
categories = client.categories.list
```

### Recipients

```ruby
listname = 'sendgrid-api list test'
marketing_email = 'sendgrid-api marketing email test'
# assign a recipient list to a marketing email
response = client.recipients.add(listname, marketing_email)
# get all lists assigned to a marketing email
lists = client.recipients.get(marketing_email)
# delete an assigned list from a marketing email
response = client.recipients.delete(listname, marketing_email)
```

### Schedule

```ruby
marketing_email = 'sendgrid-api marketing email test'
# schedule a delivery time for a marketing email
response = client.schedule.add(marketing_email) # imediately
response = client.schedule.add(marketing_email, :after => 20) # 20 minutes from now
response = client.schedule.add(marketing_email, :at => (Time.now + 10*60)) # 10 minutes from now
# retrieve the scheduled delivery time for a marketing email
schedule = client.schedule.get(marketing_email)
# cancel a scheduled delivery time for a marketing email
response = client.schedule.delete(marketing_email)
```

## Tests

This gem has offline and online tests written using RSpec. Offline tests use Webmock to stub HTTP requests, while online tests performs the requests to Sendgrid to ensure all the calls and responses are correctly.

The online tests are written in a way that they don't change the state of the objects already existing on SendGrid account. It means if something is added, it's removed at the end of the test. If something is changed, it's changed back after the test finishes. If it's necessary to remove something, it's added before the test starts.

Use the SENDGRID_USER and SENDGRID_KEY environment variables to authenticate the online tests.

To run all tests (both offline and online):
```bash
$ ALL=1 SENDGRID_USER=your_user SENDGRID_KEY=your_key bundle exec rake spec
```

To run only online tests:
```bash
$ SENDGRID_USER=your_user SENDGRID_KEY=your_key bundle exec rake spec[online]
```

To run only offline tests (default):
```bash
$ bundle exec rake spec
```

## Contributing

If you want to contribute to cover more APIs or improve something already implemented, follow these steps:

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes - do not forget tests (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
