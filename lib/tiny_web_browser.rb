require 'socket'
require 'net/http'


host = 'localhost'
port = 2000
path = '/index.html'

request = "GET #{path} HTTP/1.0\r\n\r\n"

socket = TCPSocket.open(host, port)
socket.print(request)
response = socket.read
headers, body = response.split("\r\n\r\n", 2)
status_code = headers.split[1]

if status_code == '200'
  print body
else
  puts "#{status_code}"
end

#
# host = 'localhost'
# path = '/index.html'
#
# http = Net::HTTP.new(host, 2000)
# headers, body = http.get(path)
# if headers.code == '200'
#   print body
# else
#   puts "#{headers.code} #{headers.message}"
# end