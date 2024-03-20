module Banshy
  class VideoScreen < Gtk::DrawingArea
    type_register
    attr_accessor :playing

    class << self
      def init
        set_template resource: '/com/mordrec/banshy/ui/video_screen.ui'
      end
    end

    def initialize
      super
      @pipeline = Gst::ElementFactory.make('playbin')
      @pipeline.uri = "file:///home/mordrec/workspace/banshy/index.mp4"
      @pipeline.video_sink = Gst::ElementFactory.make('gtksink', 'sink')
      @playing = false
    end

    def widget
      @pipeline.video_sink.widget
    end

    def play
      @pipeline.play
      @playing = true
    end

    def is_playing?
      @playing
    end

    def stop
      @pipeline.stop
      @playing = false
    end

    def pause
      @pipeline.pause
      @playing = false
    end

    def duration
      @pipeline.query_duration(Gst::Format::TIME).last / Gst::SECOND
    end

    def current_position
      @pipeline.query_position(Gst::Format::TIME).last / Gst::SECOND
    end
  end
end
