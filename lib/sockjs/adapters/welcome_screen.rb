# encoding: utf-8

require_relative "../adapter"

module SockJS
  class WelcomeScreen < Adapter
    self.prefix = nil
    self.method = "GET"

    def self.handle(env)
      body = "Welcome to SockJS!\n"
      [200, {"Content-Type" => "text/plain", "Content-Length" => body.bytesize.to_s}, [body]]
    end
  end
end
