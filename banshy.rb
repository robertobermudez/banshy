#!/usr/bin/env ruby
require_relative './configuration'
# Require all ruby files in the application folder recursively
Dir[File.join(APP_ROOT_PATH, 'application/**', '*.rb')].each { |file| require file }

# Define the source & target files of the glib-compile-resources command

# Build the binary
system('glib-compile-resources',
       '--target', RESOURCE_BIN,
       '--sourcedir', File.dirname(RESOURCE_XML),
       RESOURCE_XML)

Gio::Resources.register Gio::Resource.load RESOURCE_BIN

# Create files foler
FileUtils.mkdir_p PATH_FILES

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: File.join(PATH_FILES, 'data.db'),
  pool: 50
)

at_exit do
  # Before exiting, please remove the binary we produced, thanks
  FileUtils.rm_f RESOURCE_BIN
end

app = Banshy::Application.new
app.run
