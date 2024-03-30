module Banshy
  class VolumeHandler
    attr_reader :button_volume
    def initialize(volume_adj)
      @volume_adj = volume_adj
    end

    def init_buffer(buffer)
      @buffer = buffer
    end
  end
end
