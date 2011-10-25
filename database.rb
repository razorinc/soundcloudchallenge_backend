require 'rubygems'
require 'dm-core'
require 'dm-migrations'
#require 'dm-validations'
#require 'dm-timestamps'

DATABASE_FILE = "#{Dir.pwd}/soundcloud.sqlite3"

#DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, "sqlite3://#{DATABASE_FILE}")

class FileUpload

	include DataMapper::Resource

	property :id, Serial
	property :file_name, String
	property :sha1sum, String
	property :comment, Text
end

(DataMapper.auto_upgrade!;puts "Database initialized" ) unless File.exists?(DATABASE_FILE)

