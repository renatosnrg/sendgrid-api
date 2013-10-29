class Online

  attr_reader :client

  def initialize(user, key)
    @client = Sendgrid::API::Client.new(user, key)
  end

  def sender_address_example
    Sendgrid::API::Entities::SenderAddress.new(
      :identity => 'sendgrid-api sender address test',
      :name     => 'Sendgrid',
      :email    => 'contact@sendgrid.com',
      :address  => '1065 N Pacificenter Drive, Suite 425',
      :city     => 'Anaheim',
      :state    => 'CA',
      :zip      => '92806',
      :country  => 'US'
    )
  end

  def marketing_email_example
    identity = sender_address_example.identity
    Sendgrid::API::Entities::MarketingEmail.new(
      :identity => identity, 
      :name     => 'sendgrid-api marketing email test', 
      :subject  => 'My Marketing Email Test', 
      :text     => 'My text', 
      :html     => 'My HTML'
    )
  end

  def category_example
    Sendgrid::API::Entities::Category.new(
      :category => 'sendgrid-api test'
    )
  end

  def list_example
    Sendgrid::API::Entities::List.new(
      :list => 'sendgrid-api list test'
    )
  end

  def emails_example
    [
      Sendgrid::API::Entities::Email.new(:email => 'john@example.com', :name => 'John'),
      Sendgrid::API::Entities::Email.new(:email => 'brian@example.com', :name => 'Brian')
    ]
  end

  def add_marketing_email
    client.sender_addresses.add(sender_address_example)
    client.marketing_emails.add(marketing_email_example)
  end

  def delete_marketing_email
    client.marketing_emails.delete(marketing_email_example)
    client.sender_addresses.delete(sender_address_example)
  end

end