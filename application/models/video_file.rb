require 'pry'
module Banshy
  # Base class for media files (mp3,mp4 ...)
  class VideoFile < ActiveRecord::Base
    validates :name, presence: true
    validates :path, presence: true
    validates :duration, presence: true

    after_initialize do
      self.duration = get_metadata(path)['duration'].split('.').first
      self.name = File.basename(get_metadata(path)['done discovering file'],
                                '.*')
    end
    def src_path
      "file://#{self.path}"
    end

    def duration_seconds
      (Time.parse(duration) - Time.parse('00:00:00')).to_i
    end

    private

    def get_metadata(path)
      metadata = `gst-discoverer-1.0 "#{path}"`.split("\n").map(&:strip)
      metadata_hash = {}
      metadata.each do |line|
        key, value = line.split(':', 2)
        metadata_hash[key.strip.downcase] = value.strip unless key.nil? || value.nil?
      end
      metadata_hash
    end
  end
end
