require 'socket'
require 'net/http'
require 'json'


host = 'localhost'
port = 2000
socket = TCPSocket.open(host, port)
puts 'File name:'
path = '/' + gets.chomp
puts 'Method (GET or POST):'
until 'POST GET'.include? (method = gets.chomp.upcase)
  'Choose POST or GET:'
end

if method == 'POST'
  puts 'What is your name?'
  name = gets.chomp
  puts 'What is pur email address?'
  email = gets.chomp
  user = {user: {name: name, email: email}}
  request = %{#{method} #{path} HTTP/1.0\r
Content-Length: #{user.to_json.length}\r\n\r
#{user.to_json}}
else
  request = "#{method} #{path} HTTP/1.0\r\n\r\n"
end

socket.puts(request)
response = socket.read
headers, body = response.split("\r\n\r\n", 2)
status_code = headers.split[1]

if status_code == '200'
  print body
else
  puts "#{status_code}"
end