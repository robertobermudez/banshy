# frozen_string_literal: true

module Banshy
  # class for playing video files
  class MediaPlayer < Gtk::Overlay
    type_register
    class << self
      def init
        set_template resource: '/com/mordrec/banshy/ui/media_player.ui'
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

    attr_reader :playing, :file, :ready, :music_pip, :video_pip

    def initialize
      super()
      @pipeline = nil
      @file = nil
      @ready = false
      @playing = false
    end

    def load(file)
      if ready
        @pipeline.state = :null
      else
        load_pipeline
      end
      @file = file
      @pipeline = if playing_music?
                    music_pip
                  else
                    video_pip
                  end
      @pipeline.set_uri @file.src_path
      @ready = true if @pipeline.ready.to_i == 1 # Ni puta idea pero es lo que devuelve si es "succes"
    end

    def playing_music?
      file.is_a? MusicFile
    end

    def playing_video?
      file.is_a? VideoFile
    end

    def name
      @file.name
    end

    def play
      @pipeline.play if file
      @playing = true
    end

    def is_playing?
      @playing
    end

    def ready?
      ready && file
    end

    def get_volume
      @pipeline.volume
    end

    def set_volume(val)
      @pipeline.set_volume val
    end

    def stop
      @pipeline.stop
      @playing = false
    end

    def pause
      @pipeline.pause if playing
      @playing = false
    end

    def duration
      @file.duration
    end

    def move_to_position(percentage)
      aux_duration = duration_seconds != -1 ? duration_seconds : @file.duration_seconds
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

    def finished?
      current_position == duration_seconds && duration_seconds != -1
    end

    private

    def load_pipeline
      @playing = false
      load_video_pip
      load_music_pip
    end

    def load_video_pip
      @video_pip = Gst::ElementFactory.make('playbin')
      @video_pip.video_sink = Gst::ElementFactory.make('gtksink', 'sink')
      @video_pip.audio_sink = Gst::ElementFactory.make('alsasink')
      add @video_pip.video_sink.widget
    end

    def load_music_pip
      @music_pip = Gst::ElementFactory.make('playbin')
      @music_pip.audio_sink = Gst::ElementFactory.make('alsasink')
    end
  end
end
