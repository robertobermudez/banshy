module Banshy
  # Base class for media files (mp3,mp4 ...)
  class MediaFile < ActiveRecord::Base
    self.abstract_class = true
    validates :name, presence: true
    validates :path, presence: true
    validates :path, uniqueness: true
    validates :duration, presence: true

    after_initialize do
      self.duration ||= get_metadata(path)['duration'].split('.').first
      self.name ||= CGI.unescape(File.basename(get_metadata(path)['done discovering file'],
                                  '.*')).gsub('%20', ' ')
    end

    before_save do
      self.favourite ||= false
    end

    def src_path
      "file://#{self.path}"
    end

    def duration_seconds
      (Time.parse(duration) - Time.parse('00:00:00')).to_i
    end

    def to_s
      "name: #{name} duration: #{duration}"
    end

    private

    def get_metadata(path)
      puts `gst-discoverer-1.0 "#{path}"`
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
