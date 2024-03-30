module Banshy
  class MusicPlaylistMusicFile < ActiveRecord::Base
    belongs_to :music_playlist
    belongs_to :music_file
    validates :music_file_id, uniqueness: { scope: :music_playlist_id }
  end
end
