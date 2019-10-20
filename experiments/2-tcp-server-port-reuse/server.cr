require "socket"

def log(message, src)
  print "[#{Time.now}] [#{src}] #{message}\n"
end

def handle_client(name, client)
  log "Client is connected: #{client}", name
  client << "Welcome in #{name}\n"
  while message = client.gets
    log "Message: #{message}", client
    client << "#{message}\n"
  end
  log "Closing client's connection: #{client}", name
  client.close
end

name = "server"
name = ARGV[0] if ARGV.size > 0
server = TCPServer.new("0.0.0.0", 3000, reuse_port: false)
log "Listen 3000\n", name
while client = server.accept?
  spawn handle_client(name, client)
end
