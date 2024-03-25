# frozen_string_literal: true

module Banshy
  # class for playing video files
  class VideoScreen < Gtk::Overlay
    type_register
    class << self
      def init
        set_template resource: '/com/mordrec/banshy/ui/video_screen.ui'
      end
    end
    FLAG_NONE        = 0      # No flags
    FLAG_FLUSH       = 1      # Empties buffers after seek positioning
    FLAG_ACCURATE    = 2      # Accurate seek
    FLAG_KEY_UNIT    = 4      # Search in key units (Whatever it means)
    FLAG_SEGMENT     = 8      # Tries to adjust to the segment
    FLAG_SKIP        = 16     # Jumps frames to seek
    FLAG_SNAP_BEFORE = 32     # Ni idea
    FLAG_SNAP_AFTER  = 64     # Ni idea
    FLAG_TRICKMODE   = 128    # Ni puta idea
    FLAG_KEY_UNIT_EXACT = 256 # Utiliza unidades clave exactas para buscar (Y que mierdas son las unidades clave?)
    TYPE_NONE = 0             # Sin tipo (ninguno)
    TYPE_SET  = 1
    TYPE_CUR  = 2

    attr_reader :playing, :video_file, :ready
    alias file video_file

    def initialize
      super()
      @pipeline = nil
      @video_file = nil
      @ready = false
      @playing = false
    end

    def load_video(video_file)
      load_pipeline unless ready
      @video_file = video_file
      @pipeline.uri = @video_file.src_path
      @ready = true if @pipeline.ready.to_i == 1 # Ni puta idea pero es lo que devuelve si es "succes"
    end

    def name
      @video_file.name
    end

    def play
      @pipeline.play if video_file
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
      @video_file.duration
    end

    def move_to_position(percentage)
      aux_duration = duration_seconds != -1 ? duration_seconds : @media_file.duration_seconds
      seconds = ((percentage.to_f / 100) * aux_duration).round
      @pipeline.seek(1.0,
                     Gst::Format::TIME,
                     FLAG_KEY_UNIT | FLAG_FLUSH | FLAG_SEGMENT,
                     TYPE_SET,
                     seconds * Gst::SECOND,
                     TYPE_NONE,
                     -1)
    end

    def current_position
      @pipeline.query_position(Gst::Format::TIME).last / Gst::SECOND
    end

    def duration_seconds
      @pipeline.query_duration(Gst::Format::TIME).last / Gst::SECOND
    end

    private

    def load_pipeline
      @pipeline = Gst::ElementFactory.make('playbin')
      @pipeline.video_sink = Gst::ElementFactory.make('gtksink', 'sink')
      @pipeline.audio_sink = Gst::ElementFactory.make('alsasink')
      @playing = false
      add @pipeline.video_sink.widget
    end
  end
end
