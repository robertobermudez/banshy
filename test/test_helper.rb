#Dir[File.join(File.expand_path('../../lib',__FILE__),'**','*.rb')].each { |file| require file }

['lib','models'].each do |dir|
  $LOAD_PATH.unshift File.expand_path("../../application/#{dir}", __FILE__)
end

require 'minitest/autorun'
require 'minitest/reporters'
require 'glib2'
require 'media_file'
Minitest::Reporters.use!
