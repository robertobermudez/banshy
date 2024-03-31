require_relative './test_helper'
module Banshy
  class MusicFileTest < Minitest::Test
    def setup
      @music_path = File.join APP_ROOT_PATH, 'test/media/better-day-186374.mp3'
      @music = Banshy::MusicFile.new(path: @music_path)
    end

    def before_setup
      MusicFile.destroy_all
    end

    def test_creates_media_file_object
      assert @music.is_a?(Banshy::MusicFile)
    end

    def test_has_property_name
      assert @music.name == 'better-day-186374'
    end

    def test_has_property_duration
      assert @music.duration == '0:01:30'
    end

    def test_can_be_stored_in_database
      assert @music.save == true
    end

    def test_returns_file_source
      assert @music.src_path == "file://#{@music_path}"
    end

    def test_can_be_added_to_favourites
      @music.save
      @music.update(favourite: true)
      assert MusicFile.first.favourite == true
    end
  end
end
