# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
require 'resque/server'

Resque::Server.use Rack::Auth::Basic do |username, password|
  password ==  ENV['RESQUE-AUTH_PASSWORD']
end

run Rack::URLMap.new \
  "/" => Gistflow::Application,
  "/resque" => Resque::Server.new