require 'socket'
require 'json'

server = TCPServer.open(2000)
loop do
  Thread.start(server.accept) do |client|

    headers = ''
    while (line = client.gets)
      headers << line
      break if headers =~ /\r\n\r\n$/
    end

    method = headers.split[0]
    path = headers.split[1]

    body_length = headers[/content-length:\s+[0-9]+/i].split(/\s+/)[1].to_i
    body = ''
    while (char = client.getc) do
      body << char
      break if body.length >= body_length
    end

    if method == 'GET'
      # TODO: add proper headings
      if File.exists?("..#{path}")
        file = File.open("..#{path}")
        response = %{HTTP/1.0 200 OK\r\n\r
  #{file.read}}
      else
        response = %{HTTP/1.0 404 Not Found\r\n\r\n}
      end

    elsif method == 'POST'
      if File.exists?("..#{path}")
        file = File.read("..#{path}")
        params = JSON.parse(body)
        puts params
        user = ''
        params['user'].each_pair do |key, val|
          user << "<li>#{key.capitalize}: #{val}</li>"
        end
        file = file.gsub(/<%= yield %>/, user)
        response = %{HTTP/1.0 200 OK\r\n\r
        #{file}}
      else
        response = %{HTTP/1.0 404 Not Found\r\n\r\n}
      end
    end

    client.puts(response)
    client.close
  end
end