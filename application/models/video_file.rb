module Banshy
  class VideoFile < Banshy::MediaFile
    self.table_name = 'video_files'
    has_many :video_playlist_video_files, dependent: :destroy
    has_many :video_playlists, through: :video_playlist_video_files
  end
end
