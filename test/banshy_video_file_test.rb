require_relative './test_helper'
module Banshy
  class VideoFileTest < Minitest::Test
    def setup
      @video_path = '/home/mordrec/workspace/banshy/test/media/BigBuckBunny.mp4'
      @video = Banshy::VideoFile.new(path: @video_path)
    end

    def test_creates_media_file_object
      assert @video.is_a?(Banshy::VideoFile)
    end

    def test_has_property_name
      assert @video.name == 'BigBuckBunny'
    end

    def test_has_property_duration
      assert @video.duration == '0:09:56'
    end

    def test_can_be_stored_in_database
      assert @video.save == true
    end

    def test_returns_file_source
      assert @video.src_path == 'file:///home/mordrec/workspace/banshy/test/media/BigBuckBunny.mp4'
    end
  end
end
