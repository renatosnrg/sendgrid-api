shared_examples 'online tests' do
  before do
    enable_http
  end
  after do
    disable_http
  end

  let(:env_user)  { ENV['SENDGRID_USER'] }
  let(:env_key)   { ENV['SENDGRID_KEY'] }
end

shared_examples 'a success response' do
  before do
    stub_post.to_return(:body => fixture('success.json'))
  end
  its(:success?) { should be_true }
end

shared_examples 'an unauthorized response' do
  before do
    stub_post.to_return(:body => fixture('errors/unauthorized.json'), :status => 401)
  end
  it 'raises an error' do
    expect { subject }.to raise_error(Sendgrid::API::REST::Errors::Unauthorized)
  end
end

shared_examples 'a forbidden response' do
  before do
    stub_post.to_return(:body => fixture('errors/forbidden.json'), :status => 403)
  end
  it 'raises an error' do
    expect { subject }.to raise_error(Sendgrid::API::REST::Errors::Forbidden)
  end
end

shared_examples 'an invalid fields response' do
  before do
    stub_post.to_return(:body => fixture('errors/invalid_fields.json'), :status => 400)
  end
  it 'raises an error' do
    expect { subject }.to raise_error(Sendgrid::API::REST::Errors::BadRequest)
  end
end

shared_examples 'a does not exist response' do
  before do
    stub_post.to_return(:body => fixture('errors/does_not_exist.json'), :status => 401)
  end
  it 'raises an error' do
    expect { subject }.to raise_error(Sendgrid::API::REST::Errors::Unauthorized)
  end
end

shared_examples 'an already exists response' do
  before do
    stub_post.to_return(:body => fixture('errors/already_exists.json'))
  end

  it 'raises an error' do
    expect { subject }.to raise_error(Sendgrid::API::REST::Errors::UnprocessableEntity)
  end
end