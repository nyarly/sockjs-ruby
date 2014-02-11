# vim: set ft=ruby :
require 'corundum/tasklibs'

module Corundum
  Corundum::register_project(__FILE__)

  core = Core.new

  core.in_namespace do
    GemspecFiles.new(core)
    QuestionableContent.new(core) do |dbg|
      dbg.words = %w{debug! debugger}
    end
    rspec = RSpec.new(core)
    cov = SimpleCov.new(core, rspec) do |cov|
      cov.threshold = 70
      cov.coverage_filter = proc do |path|
        /\.rb$/ =~ path and /version/ !~ path
      end
    end

    gem = GemBuilding.new(core)
    cutter = GemCutter.new(core,gem)
    email = Email.new(core)
    vc = Git.new(core) do |vc|
      vc.branch = "master"
    end

    yd = YARDoc.new(core)

    docs = DocumentationAssembly.new(core, yd, rspec, cov)

    pages = GithubPages.new(docs)
  end
end

task :default => [:release, :publish_docs]


# Get list of all the tests in format for TODO.todo.

task :unpack_tests do
  version = "0.2.1"

  tests = {}
  File.foreach("protocol/sockjs-protocol-#{version}.py").each_with_object(tests) do |line, buffer|
    if line.match(/class (\w+)\(Test\)/)
      buffer[$1] = Array.new
    elsif line.match(/def (\w+)/)
      if buffer.keys.last
        buffer[buffer.keys.last] << $1
      end
    end
  end

  require "yaml"
  puts tests.to_yaml
end

desc "Run the protocol tests from https://github.com/sockjs/sockjs-protocol"
task :protocol_test, [:port] => 'protocol_test:run'

namespace :protocol_test do
  task :run, [:port] => [:collect_args, :client] do |task, args|
  end

  task :collect_args, [:port] do |task, args|
    $TEST_PORT = (args[:port] || ENV["TEST_PORT"] || 8081)
  end

  task :check_port do
    begin
      test_conn = TCPSocket.new 'localhost', $TEST_PORT
      fail "Something is still running on localhost:#$TEST_PORT"
    rescue Errno::ECONNREFUSED
      #That's what we're hoping for
    ensure
      test_conn.close rescue nil
    end
  end

  task :run_server => :check_port do
    $server_pid = Process::fork do
      sh "rake -t protocol_test:server[#$TEST_PORT]"
    end

    %w{EXIT TERM}.each do |signal|
      trap(signal) do
        Process::kill('KILL', $server_pid) rescue nil
        Process::wait($server_pid)
      end
    end

    begin_time = Time.now
    begin
      test_conn = TCPSocket.new 'localhost', $TEST_PORT
    rescue Errno::ECONNREFUSED
      if Time.now - begin_time > 10
        raise "Couldn't connect to test server in 10 seconds - bailing out"
      else
        retry
      end
    ensure
      test_conn.close rescue nil
    end
  end

  task :client => :run_server do
    require 'sockjs/version'
    sh "protocol/venv/bin/python protocol/sockjs-protocol-#{SockJS::PROTOCOL_VERSION_STRING}.py #{ENV["TEST_NAME"]}"
  end

  desc "Run the protocol test server"
  task :server, [:port] do |task, args|
    require "thin"
    require 'em/pure_ruby'
    #require "eventmachine"
    require 'sockjs/examples/protocol_conformance_test'

    $DEBUG = true

    PORT = args[:port] || 8081

    ::Thin::Connection.class_eval do
      def handle_error(error = $!)
        log "[#{error.class}] #{error.message}\n  - "
        log error.backtrace.join("\n  - ")
        close_connection rescue nil
      end
    end

    SockJS.debug!
    SockJS.debug "Available handlers: #{::SockJS::Endpoint.endpoints.inspect}"

    protocol_version = args[:version] || SockJS::PROTOCOL_VERSION
    options = {sockjs_url: "http://cdn.sockjs.org/sockjs-#{protocol_version}.min.js"}

    app = SockJS::Examples::ProtocolConformanceTest.build_app(options)

    EM.run do
      thin = Rack::Handler.get("thin")
      thin.run(app, Port: PORT)
    end
  end
end
