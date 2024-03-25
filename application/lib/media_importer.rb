require 'pry'
module Banshy
  class MediaImporter
    class << self
      def import(paths,opts = {})
        filter = opts.fetch(:filter) { 'all' }
        import_type = opts.fetch(:import_type)
        media_files = case import_type
                      when 'folder' then import_folders filter, paths
                      when 'file'   then import_files filter, paths
                      end
        media_files.select(&:save)
      end

      def import_folders(filter, folders)
        folders.map { |folder| import_folder(filter, folder) }.reduce(:+)
      end

      def import_folder(filter, folder)
        file_paths = []
        Dir.foreach(folder) do |file|
          file_path = File.join(folder, file)
          next if file == '.' || file == '..' || File.directory?(file_path)

          file_paths << file_path
        end
        import_files(filter, file_paths)
      end

      def import_files(filter, paths)
        paths.map { |path| create_media_obj(filter, path) }.compact
      end

      def create_media_obj(filter, path)
        result = analyze_file(path)
        if result == filter || filter == 'all'
          if result == 'music'
            MusicFile.new(path: path)
          elsif result == 'video'
            VideoFile.new(path: path)
          end
        end
      end

      def analyze_file(path)
        metadata = `gst-discoverer-1.0 "#{path}"`.split("\n").map(&:strip)
        if metadata.find { |str| str.start_with? 'video' }
          'video'
        elsif metadata.find { |str| str.start_with? 'audio' }
          'music'
        end
      end
    end
  end
end
