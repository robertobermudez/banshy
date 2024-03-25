require 'rake/testtask'
require './configuration'

task :shell do
  pry.START
end

task default: 'test'

Rake::TestTask.new do |task|
  task.pattern = 'test/*_test.rb'
end

def connect_db
  ActiveRecord::Base.establish_connection(adapter: 'sqlite3',
                                          database: File.join(PATH_FILES,
                                                              'data.db'))
end

def connect_test_db
  ActiveRecord::Base.establish_connection(adapter: 'sqlite3',
                                          database: PATH_DB_TEST)
end

namespace :migrate do
  task :up do
    require './migrations'
    connect_db
    CreateVideoFileTable.migrate :up
    CreateMusicFileTable.migrate :up
  end
  task :down do
    require './migrations'
    connect_db
    CreateVideoFileTable.migrate :down
    CreateMusicFileTable.migrate :down
  end
end

namespace :migrate_test do
  task :up do
    require './migrations'
    connect_test_db
    CreateVideoFileTable.migrate :up
    CreateMusicFileTable.migrate :up
  end
  task :down do
    require './migrations'
    connect_test_db
    CreateVideoFileTable.migrate :down
    CreateMusicFileTable.migrate :down
  end
end

Rake::Task['test'].enhance ['migrate_test:down',
                            'migrate_test:up']
