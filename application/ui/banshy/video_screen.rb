# frozen_string_literal: true

module Banshy
  # class for playing video files
  class VideoScreen
    FLAG_NONE        = 0   # No flags
    FLAG_FLUSH       = 1   # Empties buffers after seek positioning
    FLAG_ACCURATE    = 2   # Accurate seek
    FLAG_KEY_UNIT    = 4   # Search in key units (Whatever it means)
    FLAG_SEGMENT     = 8   # Tries to adjust to the segment
    FLAG_SKIP        = 16  # Jumps frames to seek
    FLAG_SNAP_BEFORE = 32  # Busca a la posición más cercana antes del valor de búsqueda
    FLAG_SNAP_AFTER  = 64  # Busca a la posición más cercana después del valor de búsqueda
    FLAG_TRICKMODE   = 128 # Reproducción en modo truco
    FLAG_KEY_UNIT_EXACT = 256 # Utiliza unidades clave exactas para buscar
    TYPE_NONE = 0    # Sin tipo (ninguno)
    TYPE_SET  = 1
    TYPE_CUR  = 2

    attr_accessor :playing

    def initialize(media_file)
      super()
      @media_file = media_file
      @pipeline = Gst::ElementFactory.make('playbin')
      @pipeline.uri = @media_file.src_path
      @pipeline.video_sink = Gst::ElementFactory.make('gtksink', 'sink')
      @pipeline.audio_sink = Gst::ElementFactory.make('alsasink')
      @playing = false
      @pipeline.ready
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

    def move_to_position(percentage)
      aux_duration = duration != -1 ? duration : @media_file.duration_seconds
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

    def duration
      @pipeline.query_duration(Gst::Format::TIME).last / Gst::SECOND
    end
  end
end
