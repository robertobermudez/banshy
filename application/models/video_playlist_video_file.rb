module Banshy
  class VideoPlaylistVideoFile < ActiveRecord::Base
    belongs_to :video_playlist
    belongs_to :video_file
    validates :video_file_id, uniqueness: { scope: :video_playlist_id }
  end
end
