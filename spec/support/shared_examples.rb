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