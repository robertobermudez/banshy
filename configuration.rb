APP_ROOT_PATH = File.expand_path(__dir__).freeze
PATH_FILES = File.join(ENV['HOME'], '/.banshy/').freeze
PATH_DB_TEST = File.join(APP_ROOT_PATH, 'test', 'datab.db').freeze
RESOURCE_XML = File.join(APP_ROOT_PATH, 'resources', 'gresources.xml').freeze
RESOURCE_BIN = File.join(APP_ROOT_PATH, 'gresource.bin').freeze
$LOAD_PATH.unshift File.expand_path(APP_ROOT_PATH, 'lib/gems').freeze

require 'gtk3'
require 'fileutils'
require 'gstreamer'
require 'glib2'
require 'sqlite3'
require 'active_record'
require 'logger'
require 'singleton'
require 'rake'

# Require all ruby files in the application folder recursively
Dir[File.join(APP_ROOT_PATH, 'application/**', '*.rb')].each { |file| require file }

# Define the source & target files of the glib-compile-resources command
