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

    if File.exists?("..#{path}")
      file = File.read("..#{path}")
      header_lines = %{Content-Length: #{file.length}\r\n\r}

      if method == 'GET'
        # TODO: add proper headings
        response = %{HTTP/1.0 200 OK\r
#{header_lines}
#{file}}

      elsif method == 'POST'
        body_length = headers[/content-length:\s+[0-9]+/i].split(/\s+/)[1].to_i
        body = ''
        while (char = client.getc) do
          body << char
          break if body.length >= body_length
        end
          params = JSON.parse(body)
          user = ''
          params['user'].each_pair do |key, val|
            user << "<li>#{key.capitalize}: #{val}</li>"
          end
          file = file.gsub(/<%= yield %>/, user)
          response = %{HTTP/1.0 200 OK\r
          #{header_lines}
          #{file}}
      end

    else
      response = %{HTTP/1.0 404 Not Found\r
      #{header_lines}}
    end

    puts response
    client.puts(response)
    client.close
  end
end