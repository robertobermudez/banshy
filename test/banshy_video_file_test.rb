require_relative './test_helper'
module Banshy
  class VideoFileTest < Minitest::Test
    def setup
      @video_path = File.join APP_ROOT_PATH, 'test/media/recorte.mp4'
      @video = Banshy::VideoFile.new(path: @video_path)
    end

    def before_setup
      VideoFile.destroy_all
    end

    def test_creates_media_file_object
      assert @video.is_a?(Banshy::VideoFile)
    end

    def test_has_property_name
      assert @video.name == 'recorte'
    end

    def test_has_property_duration
      assert @video.duration == '0:00:23'
    end

    def test_can_be_stored_in_database
      VideoFile.destroy_all
      assert @video.save == true
    end

    def test_returns_file_source
      assert @video.src_path == "file://#{@video_path}"
    end

    def test_can_be_added_to_favourites
      @video.save
      @video.update(favourite: true)
      assert VideoFile.first.favourite == true
    end
  end
end
