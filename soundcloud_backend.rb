require 'sinatra'
require 'json'
require 'lib/rack/raw_upload'
require 'fileutils'
require 'database'
require 'digest/sha1'

get '/' do
  @uploads=FileUpload.all
  haml :index
end

post '/' do
  puts params.inspect
  # This come from the submission
  filename = params[:file][:filename]
  # This is a Filetemp object created from the submission
  tempFile = params[:file][:tempfile].path
  uploaded_path_file = File.join(File.expand_path(File.dirname(File.dirname(__FILE__))),"public","#{filename}")
  sha1sum = Digest::SHA1.hexdigest(uploaded_path_file)
  # This move the file from the temporary directory to the public directory
  (FileUtils.mv(tempFile, uploaded_path_file);puts "File not existent" ) unless File.exists?(uploaded_path_file)
  status = FileUpload.create(:file_name=>filename,:sha1sum=>sha1sum)
  if status
    puts "Creato"
  else
    puts "Non creato"
  end
  # Set up the HTTP status to 201 (Created) and return the JSON informations that we need.
  [201,JSON.generate(
                {:type=>params[:file][:type],
                :file=>filename,
                :file_path=>uploaded_path_file,
                :filename=>sha1sum}
               ) ]
end


post '/comment' do
  puts "|#{params.inspect}|".center(50,'-')
  current_file = FileUpload.first(:sha1sum=>params[:sha1sum]).update(:comment=>params[:comment])
  if current_file
    puts "Aggiunto il commento al file"
  else
    puts "Huston we've a problem!"
  end
  redirect '/'
end
