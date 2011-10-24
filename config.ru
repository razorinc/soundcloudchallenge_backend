require 'rubygems'
require 'rack'
require 'sinatra'
require 'soundcloud_backend'

set :root, File.dirname(__FILE__)
set :public, Proc.new{File.join(root,'public')}
use Rack::RawUpload
run Sinatra::Application
