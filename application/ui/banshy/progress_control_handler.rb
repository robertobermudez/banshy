module Banshy
  class ProgressControlHandler
    attr_reader :time_label, :prog_adj, :buffer, :update_timer
    def initialize(time_label, prog_adj, buffer)
      @time_label = time_label
      @prog_adj = prog_adj
      @buffer = buffer
    end

    def start_update_timer
      @update_timer = GLib::Timeout.add(500) do
        if buffer.is_playing? && buffer.duration != -1
          update_progress_label
          update_progress_adjustement
        end
        true
      end
    end


    def stop_update_timer
      GLib::Source.remove @update_timer if @update_timer
      @update_timer = nil
    end


    private

    def update_progress_adjustement
      percentage = ((@buffer.current_position.to_f / @buffer.duration) * 100).round(2)
      prog_adj.value = percentage
    end

    def update_progress_label
      @time_label.text = time_format @buffer.current_position
    end

    def time_format(seconds)
      [seconds / 3600, seconds / 60 % 60, seconds % 60].map{|t| t.to_s.rjust(2,'0')}.join(':')
    end
  end
end
