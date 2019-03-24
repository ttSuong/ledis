require './lib/ledis'
require 'rack'
@root = File.expand_path(File.dirname(__FILE__))

cli = Ledis::CLI.new

run lambda {|env|
  req = Rack::Request.new(env)
  if req.post?
    data = cli.start(req.body.read)
    [200, {'Content-Type' => 'text/html'},  [data]]
  elsif req.get?
    path = Rack::Utils.unescape(env['PATH_INFO'])
    index_file = @root + "#{path}app/index.html"
    puts index_file
    if File.exists?(index_file)
      # Return the index
      [200, {'Content-Type' => 'text/html'}, [File.read(index_file)]]
    else
      # Pass the request to the directory app
      Rack::Directory.new(@root).call(env)
    end
  end
}

