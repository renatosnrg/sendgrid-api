def fixture_path
  File.expand_path("../../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end

def enable_http
  WebMock.allow_net_connect!
end

def disable_http
  WebMock.disable_net_connect!(:allow => 'coveralls.io')
end

def sample_file(options = {})
  name = options[:name] || 'sample.txt'
  type = options[:type] || 'plain/text'
  content = options[:content] || 'This is my file content'
  stream = StringIO.new(content)
  Faraday::UploadIO.new(stream, type, name)
end