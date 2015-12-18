#!/usr/bin/env gem build
# encoding: utf-8

require "base64"

require File.expand_path("../lib/sockjs/version", __FILE__)

Gem::Specification.new do |s|
  s.name     = "sockjs"
  s.version  = SockJS::GEM_VERSION
  s.authors  = ["Judson Lester"]
  s.email    = "nyarly@gmail.com"
  s.homepage = "https://github.com/nyarly/sockjs-ruby"
  s.summary  = "Ruby server for SockJS"
  s.description = <<-DESC
    SockJS is a WebSocket emulation library. It means that you use the WebSocket API, only instead of WebSocket class you instantiate SockJS class. In absence of WebSocket, some of the fallback transports will be used. This code is compatible with SockJS protocol #{SockJS::PROTOCOL_VERSION_STRING}.
  DESC

  # Ruby version
  s.required_ruby_version = ::Gem::Requirement.new(">= 1.9")

  # Dependencies
  s.add_dependency "rack"
  s.add_dependency "thin"
  s.add_dependency "json"
  s.add_dependency "faye-websocket", "~> 0.7.1"
  s.add_dependency "rack-mount", "~> 0.8.3"

  # Files
  s.files = %w{
    LICENCE
    README.textile
    lib/meta-state.rb
    lib/rack/sockjs.rb
    lib/sockjs.rb
    lib/sockjs/delayed-response-body.rb
    lib/sockjs/duck-punch-rack-mount.rb
    lib/sockjs/duck-punch-thin-response.rb
    lib/sockjs/callbacks.rb
    lib/sockjs/connection.rb
    lib/sockjs/examples/protocol_conformance_test.rb
    lib/sockjs/faye.rb
    lib/sockjs/protocol.rb
    lib/sockjs/servers/request.rb
    lib/sockjs/servers/response.rb
    lib/sockjs/session.rb
    lib/sockjs/transport.rb
    lib/sockjs/transports/eventsource.rb
    lib/sockjs/transports/htmlfile.rb
    lib/sockjs/transports/iframe.rb
    lib/sockjs/transports/info.rb
    lib/sockjs/transports/jsonp.rb
    lib/sockjs/transports/websocket.rb
    lib/sockjs/transports/welcome_screen.rb
    lib/sockjs/transports/xhr.rb
    lib/sockjs/version.rb
    spec/sockjs/protocol_spec.rb
    spec/sockjs/session_spec.rb
    spec/sockjs/transport_spec.rb
    spec/sockjs/transports/eventsource_spec.rb
    spec/sockjs/transports/htmlfile_spec.rb
    spec/sockjs/transports/iframe_spec.rb
    spec/sockjs/transports/jsonp_spec.rb
    spec/sockjs/transports/websocket_spec.rb
    spec/sockjs/transports/welcome_screen_spec.rb
    spec/sockjs/transports/xhr_spec.rb
    spec/sockjs/version_spec.rb
    spec/sockjs_spec.rb
    spec/spec_helper.rb
    spec/support/async-test.rb
  }
  s.require_paths = ["lib"]

  s.extra_rdoc_files = ["README.textile"]

  # RubyForge
  s.rubyforge_project = "sockjs"
end
