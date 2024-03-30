module Banshy
  class MusicPlaylist < Banshy::MediaPlaylist
    self.table_name = 'music_playlists'
    has_many :music_playlist_music_files, dependent: :destroy
    has_many :music_files, through: :music_playlist_music_files
  end
end
