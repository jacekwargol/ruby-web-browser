require 'socket'

server = TCPServer.open(2000)
loop do
  Thread.start(server.accept) do |client|
    request = client.gets

    if request.split[0] == 'GET'
      file = File.open('../index.html')
      response = %{
HTTP/1.0 200 OK\r\n\r
#{file.read}}

      puts 'sent'
      client.puts(response)
      puts response
    end
    client.close
  end
end