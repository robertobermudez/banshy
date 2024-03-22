require 'pry'
module Banshy
  class MediaFile
    attr_accessor :path, :duration, :metadata_hash

    def initialize(file_path)
      @path = file_path
      @metadata_hash = get_metadata(@path)
      @duration = @metadata_hash['duration'].split(".")[0]
    end

    def src_path
      "file://#{path}"
    end

    def duration_seconds
      (Time.parse(duration) - Time.parse("00:00:00")).to_i
    end

    private

    def get_metadata(file_path)
        metadata = `gst-discoverer-1.0 "#{file_path}"`.split("\n").map(&:strip)
        metadata_hash = {}

        metadata.each do |line|
          key, value = line.split(":", 2)
          metadata_hash[key.strip.downcase] = value.strip unless key.nil? || value.nil?
        end
       metadata_hash
    end
  end
end
