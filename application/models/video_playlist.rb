module Banshy
  class VideoPlaylist < Banshy::MediaPlaylist
    self.table_name = 'video_playlists'
    has_many :video_playlist_video_files, dependent: :destroy
    has_many :video_files, through: :video_playlist_video_files
  end
end
