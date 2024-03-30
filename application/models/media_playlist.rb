module Banshy
  class MediaPlaylist < ActiveRecord::Base
    self.abstract_class = true
    validates :name, presence: true
    validates :name, uniqueness: true
  end
end
