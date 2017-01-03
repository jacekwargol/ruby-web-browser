require 'socket'
require 'net/http'
require 'json'


host = 'localhost'
port = 2000
socket = TCPSocket.open(host, port)
path = '/thanks.html'
method = 'GET'

if method == 'POST'
  # puts 'What is your name?'
  # name = gets.chomp
  # puts 'What is pur email address?'
  # email = gets.chomp
  name = 'a'
  email = 'em'
  user = {user: {name: name, email: email}}
  # TODO: add proper headings
  request = %{#{method} #{path} HTTP/1.0\r
Content-Length: #{user.to_json.length}\r\n\r
#{user.to_json}}
else
  request = "#{method} #{path} HTTP/1.0\r\n\r\n"
end

puts request
socket.puts(request)
response = socket.read
headers, body = response.split("\r\n\r\n", 2)
status_code = headers.split[1]

if status_code == '200'
  print body
else
  puts "#{status_code}"
end