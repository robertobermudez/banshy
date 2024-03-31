require_relative './test_helper'
module Banshy
  class MediaImporterTest < Minitest::Test
    def setup
      @video_path =  File.join APP_ROOT_PATH, 'test/media/recorte.mp4'
      @music_path = File.join APP_ROOT_PATH, 'test/media/better-day-186374.mp3'
      @fake_video = File.join APP_ROOT_PATH, 'test/media/fake_video.mp4'
      @fake_music = File.join APP_ROOT_PATH, 'test/media/fake_music.mp3'
      @folder = File.join APP_ROOT_PATH, 'test/media'
      @folder2 = File.join APP_ROOT_PATH, 'test/media/media2'
    end

    def before_setup
      VideoFile.destroy_all
      MusicFile.destroy_all
    end

    def test_returns_the_type_of_file_media
      assert MediaImporter.analyze_file(@music_path) == 'music'
      assert MediaImporter.analyze_file(@video_path) == 'video'
      assert MediaImporter.analyze_file(@fake_video).nil?
      assert MediaImporter.analyze_file(@fake_music).nil?
    end

    def test_returns_an_object_of_type_media
      assert MediaImporter.create_media_obj('all', @video_path).is_a?(Banshy::VideoFile)
      assert MediaImporter.create_media_obj('video', @video_path).is_a?(Banshy::VideoFile)
      assert MediaImporter.create_media_obj('music', @video_path).nil?
      assert MediaImporter.create_media_obj('all', @music_path).is_a?(Banshy::MusicFile)
      assert MediaImporter.create_media_obj('music', @music_path).is_a?(Banshy::MusicFile)
      assert MediaImporter.create_media_obj('video', @music_path).nil?
      assert MediaImporter.create_media_obj('all', @fake_video).nil?
      assert MediaImporter.create_media_obj('music', @fake_video).nil?
      assert MediaImporter.create_media_obj('video', @fake_video).nil?
      assert MediaImporter.create_media_obj('all', @fake_music).nil?
      assert MediaImporter.create_media_obj('music', @fake_music).nil?
      assert MediaImporter.create_media_obj('video', @fake_music).nil?
    end

    def test_import_files_return_array_with_video_files
       result = Banshy::MediaImporter.import_files('all', [@video_path])
       assert result.is_a? Array
       assert result.any?
       assert result.first.is_a? Banshy::VideoFile
    end

    def test_import_files_filters_fake_video_files
       result = Banshy::MediaImporter.import_files('all', [@video_path,
                                                           @fake_video])
       assert result.is_a? Array
       assert result.size == 1
       assert result.first.is_a? Banshy::VideoFile
    end

    def test_import_files_return_array_with_music_files
       result = Banshy::MediaImporter.import_files('all', [@music_path])
       assert result.is_a? Array
       assert result.any?
       assert result.first.is_a? Banshy::MusicFile
    end

    def test_import_files_filters_fake_music_files
       result = Banshy::MediaImporter.import_files('all', [@music_path,
                                                           @fake_music])
       assert result.is_a? Array
       assert result.size == 1
       assert result.first.is_a? Banshy::MusicFile
    end

    def test_import_folder_returns_an_array_media_files
      result = Banshy::MediaImporter.import_folder('all', @folder)
      assert result.is_a? Array
      assert result.size == 2
    end

    def test_import_folders_returns_an_array_of_media_files
      result = Banshy::MediaImporter.import_folders('all', [@folder,
                                                            @folder2])
      assert result.is_a? Array
      assert result.size == 3
    end

    def test_importer_saves_and_returns_an_array_of_saved_files
      result = Banshy::MediaImporter.import([@folder, @folder2],
                                            import_type: 'folder')
      assert result.size == 3
      assert MusicFile.all.count == 1
      assert VideoFile.all.count == 2
      result2 = Banshy::MediaImporter.import([@folder, @folder2],
                                             import_type: 'folder')
      assert result2.empty?
    end

    def test_import_filters_not_matching_video_files
      result = Banshy::MediaImporter.import([@folder, @folder2],
                                            import_type: 'folder',
                                            filter: 'video')
      assert result.size == 2
      assert MusicFile.all.count.zero?
      assert VideoFile.all.count == 2
    end

    def test_import_filters_not_matching_music_files
      result = Banshy::MediaImporter.import([@folder, @folder2],
                                            import_type: 'folder',
                                            filter: 'music')
      assert result.size == 1
      assert MusicFile.all.count == 1
      assert VideoFile.all.count.zero?
    end
  end
end
