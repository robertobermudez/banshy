require_relative './test_helper'
module Banshy
  class VideoPlaylistTest < Minitest::Test
    def setup
      @video_path = File.join APP_ROOT_PATH, 'test/media/recorte.mp4'
      puts @video_path
      @video = Banshy::VideoFile.new(path: @video_path)
      @pl_name = 'new'
      @pl = Banshy::VideoPlaylist.new name: @pl_name
    end

    def before_setup
      VideoFile.destroy_all
      VideoPlaylist.destroy_all
    end

    def test_creates_video_playlist_object
      assert @pl.is_a? Banshy::VideoPlaylist
    end

    def test_has_property_name
      assert @pl.name == @pl_name
    end

    def test_can_be_stored_in_db
      assert @pl.save == true
    end

    def test_can_own_music_files
      @pl.save
      @video.save
      playlist = VideoPlaylist.first
      video_file = VideoFile.first
      playlist.video_files << video_file
      assert playlist.video_files.first == @video
      assert video_file.video_playlists.first == @pl
    end

    def test_association_dissapears_on_destroy_video_file
      @pl.save
      @video.save
      @pl.video_files << @video
      @video.destroy
      assert VideoPlaylist.first.video_files.empty?
    end

    def test_association_dissapears_on_destroy_video_playlist
      @pl.save
      @video.save
      @pl.video_files << @video
      @pl.destroy
      assert VideoFile.first.video_playlists.empty?
    end
  end
end
