require 'rubygems'
require 'bundler'

Bundler.setup

require 'rack/no-www'
require 'rack/robustness'

require 'bourbon'
require 'sprockets'
require 'sprockets-helpers'

require './lib/helpers'
require './lib/base'
require './lib/app'
require './lib/api'
require './lib/account.rb'
require './lib/github'
require './lib/pebble'

configure :production do 
  require "newrelic_rpm"
end

use Rack::NoWWW
use Rack::Static, :urls => ["/files", "/font","/img", "/scripts","/css"], :root => "public"

class HuboardAssets < Sprockets::Environment
  load ".settings"
end
environment = HuboardAssets.new

map "/api" do
  run Huboard::API
end

map "/" do 
  run Huboard::App
end

map "/settings" do 
    run Huboard::Accounts
end

map "/assets" do
  environment.append_path 'assets/javascripts'
  environment.append_path 'assets/stylesheets'
  run environment
end

