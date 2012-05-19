# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
require 'resque/server'

resque_config = YAML.load_file("#{Rails.root}/config/resque.yml")

AUTH_PASSWORD = resque_config[:password]
if AUTH_PASSWORD
  Resque::Server.use Rack::Auth::Basic do |username, password|
    password == AUTH_PASSWORD
  end
end

run Rack::URLMap.new \
  "/" => Gistflow::Application,
  "/resque" => Resque::Server.new