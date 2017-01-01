require 'socket'

server = TCPServer.open(2000)
loop do
  Thread.start(server.accept) do |client|
    request = client.gets
    path = request.split[1]

    if request.split[0] == 'GET'

      # TODO: add proper headings
      if File.exists?("..#{path}")
        file = File.open("..#{path}")
        response = %{HTTP/1.0 200 OK\r\n\r
  #{file.read}}
      else
        response = %{HTTP/1.0 404 Not Found\r\n\r\n}
      end
      client.puts(response)
    end
    client.close
  end
end