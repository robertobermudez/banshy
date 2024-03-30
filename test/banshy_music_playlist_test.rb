require_relative './test_helper'
module Banshy
  class MusicPlaylistTest < Minitest::Test
    def setup
      @music_path = '/home/mordrec/workspace/banshy/test/media/better-day-186374.mp3'
      @music = Banshy::MusicFile.new(path: @music_path)
      @pl_name = 'new'
      @pl = Banshy::MusicPlaylist.new name: @pl_name
    end

    def before_setup
      MusicFile.destroy_all
      MusicPlaylist.destroy_all
    end

    def test_creates_video_playlist_object
      assert @pl.is_a? Banshy::MusicPlaylist
    end

    def test_has_property_name
      assert @pl.name == @pl_name
    end

    def test_can_be_stored_in_db
      assert @pl.save == true
    end

    def test_can_own_music_files
      @pl.save
      @music.save
      playlist = MusicPlaylist.first
      music_file = MusicFile.first
      playlist.music_files << music_file
      assert playlist.music_files.first == @music
      assert music_file.music_playlists.first == @pl
    end
  end
end
