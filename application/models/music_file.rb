module Banshy
  class MusicFile < Banshy::MediaFile
    self.table_name = 'music_files'
    has_many :music_playlist_music_files, dependent: :destroy
    has_many :music_playlists, through: :music_playlist_music_files

    after_commit :reload_playlists, on: :destroy

    def reload_playlists
      music_playlists.each(&:reload) if music_playlists.any?
    end
  end
end
