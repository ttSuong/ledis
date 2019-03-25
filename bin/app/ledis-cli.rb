require 'rest-client'
require 'json'
while true
  printf 'cli>'
  input = gets.chomp
  url = 'https://ledisapp.herokuapp.com'
  if input.length > 0
   begin
     response = RestClient.post(url, input)
     response = JSON.parse(response)
     puts "data: #{response['data']}"
     puts "message: #{response['message']}"
   rescue => e
     puts e.response
   end
  end

end