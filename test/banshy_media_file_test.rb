require_relative './test_helper'

module Banshy
  class MediaFileTest < Minitest::Test
    def setup
      @video_path = '/home/mordrec/workspace/banshy/test/media/BigBuckBunny.mp4'
      @video = Banshy::MediaFile.new(@video_path)
    end

    def test_creates_media_file_object
      assert @video.is_a?(Banshy::MediaFile)
    end

    def test_has_property_duration
      assert @video.duration == '0:09:56'
    end

    def test_returns_file_source
      assert @video.src_path == 'file:///home/mordrec/workspace/banshy/test/media/BigBuckBunny.mp4'
    end
  end
end
