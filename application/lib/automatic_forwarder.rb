module Banshy
  class AutomaticForwarder
    attr_reader :parent, :buffer
    def initialize(parent, buffer)
      @parent = parent
      @buffer = buffer
    end

    def start
      @progress_watcher = GLib::Timeout.add 1100 do
        parent.next_behavior if buffer&.is_playing? && buffer&.finished?
        true
      end
    end

    def stop
      GLib::Source.remove @progress_watcher if @progress_watcher
      @progress_watcher = nil
    end
  end
end
