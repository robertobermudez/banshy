class CreateVideoFileTable < ActiveRecord::Migration[7.1]
  def up
    unless ActiveRecord::Base.connection.table_exists? :video_files
      create_table :video_files do |table|
        table.string :name
        table.string :path
        table.string :duration
        table.boolean :favourite
        table.timestamps
        table.index :id
        table.index :favourite
      end
    end
  end

  def down
    drop_table(:video_files) if ActiveRecord::Base.connection.table_exists?(:video_files)
  end
end

class CreateVideoPlaylistTable < ActiveRecord::Migration[7.1]
  def up
    unless ActiveRecord::Base.connection.table_exists? :video_playlists
      create_table :video_playlists do |table|
        table.string :name
      end
    end
  end
  def down
    drop_table(:video_playlists) if ActiveRecord::Base.connection.table_exists?(:video_playlists)
  end
end

class CreateVideoPlaylistVideoFilesTable < ActiveRecord::Migration[7.1]
  def up
    unless ActiveRecord::Base.connection.table_exists? :video_playlist_video_files
      create_table :video_playlist_video_files do |t|
        t.references :video_playlist, foreign_key: true
        t.references :video_file, foreign_key: true
      end
    end
  end

  def down
    drop_table(:video_playlist_video_files) if ActiveRecord::Base.connection.table_exists?(:video_playlist_video_files)
  end
end

class CreateMusicFileTable < ActiveRecord::Migration[7.1]
  def up
    unless ActiveRecord::Base.connection.table_exists? :music_files
      create_table :music_files do |table|
        table.string :name
        table.string :path
        table.string :duration
        table.boolean :favourite
        table.timestamps
        table.index :id
        table.index :favourite
      end
    end
  end

  def down
    drop_table(:music_files) if ActiveRecord::Base.connection.table_exists?(:music_files)
  end
end

class CreateMusicPlayListTable < ActiveRecord::Migration[7.1]
  def up
    unless ActiveRecord::Base.connection.table_exists? :music_playlists
      create_table :music_playlists do |table|
        table.string :name
      end
    end
  end
  def down
    drop_table(:music_playlists) if ActiveRecord::Base.connection.table_exists?(:music_playlists)
  end
end

class CreateMusicPlaylistMusicFilesTable < ActiveRecord::Migration[7.1]
  def up
    unless ActiveRecord::Base.connection.table_exists? :music_playlist_music_files
      create_table :music_playlist_music_files do |t|
        t.references :music_playlist, foreign_key: true
        t.references :music_file, foreign_key: true
      end
    end
  end

  def down
    drop_table(:music_playlist_music_files) if ActiveRecord::Base.connection.table_exists?(:music_playlist_music_files)
  end
end
