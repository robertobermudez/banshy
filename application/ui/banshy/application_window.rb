require 'pry'
module Banshy
  class ApplicationWindow < Gtk::ApplicationWindow
    type_register
    class << self
      def init
        set_template resource: '/com/mordrec/banshy/ui/application_window.ui'
        bind_template_child 'menu_bar'
        bind_template_child 'swap_area'
        bind_template_child 'side_view'
        bind_template_child 'button_play'
        bind_template_child 'button_pause'
        bind_template_child 'progress_control'
        bind_template_child 'progress_adjustement'
        bind_template_child 'time_label'
        bind_template_child 'progress_label'
      end
    end

    def initialize(application)
      super(application: application)
      set_title "Banshy!"
      @media_file = MediaFile.new(
        '/home/mordrec/workspace/banshy/test/media/BigBuckBunny.mp4')
      @video_screen = Banshy::VideoScreen.new(@media_file)
      swap_area.add @video_screen.widget
      set_progress_control
      init_behaviors
      set_time_label
      show_all
    end

    def init_behaviors
      play_behavior
      pause_behavior
      progress_control_behavior
    end

    def set_time_label
      time_label.text = @media_file.duration
      progress_label.text = '00:00:00'
    end

    def play_behavior
      button_play.signal_connect 'clicked' do
        @video_screen.play
        @progress_control_handler.start_update_timer
      end
    end

    def pause_behavior
      button_pause.signal_connect 'clicked' do
        @video_screen.pause
        @progress_control_handler.stop_update_timer
      end
    end

    def progress_control_behavior
      was_playing = nil
      progress_control.signal_connect 'change-value' do
        was_playing ||= @video_screen.is_playing?
        @video_screen.pause if @video_screen.is_playing?
      end

      progress_control.signal_connect_after 'change-value' do
        @video_screen.play if was_playing
        @video_screen.move_to_position progress_control.value
        was_playing = nil
      end
    end

    def set_progress_control
      @progress_control_handler = ProgressControlHandler.new(progress_label,
                                                     progress_adjustement,
                                                     @video_screen)
    end

    private

    def time_format(seconds)
      [seconds / 3600, seconds / 60 % 60, seconds % 60].map{|t| t.to_s.rjust(2,'0')}.join(':')
    end
  end
end
