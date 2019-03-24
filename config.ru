@root = File.expand_path(File.dirname(__FILE__))
run Proc.new do |env|
    path = Rack::Utils.unescape(env['PATH_INFO'])
    index_file = @root + "#{path}app/index.html.erb"
    if File.exists?(index_file)
      # Return the index
      [200, {'Content-Type' => 'text/html'}, [File.read(index_file)]]
    else
      # Pass the request to the directory app
      Rack::Directory.new(@root).call(env)
    end
end