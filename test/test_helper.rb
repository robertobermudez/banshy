require_relative '../configuration'
require 'minitest/autorun'
require 'minitest/reporters'
require 'glib2'
Minitest::Reporters.use!

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: PATH_DB_TEST
)
