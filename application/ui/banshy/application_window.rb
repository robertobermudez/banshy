module Banshy
  class ApplicationWindow < Gtk::ApplicationWindow
    type_register
    class << self
      def init
        set_template resource: '/com/mordrec/banshy/ui/application_window.ui'
        bind_template_child 'side_view'
        bind_template_child 'button_play'
        bind_template_child 'button_pause'
        bind_template_child 'progress_control'
        bind_template_child 'progress_adjustement'
        bind_template_child 'time_label'
        bind_template_child 'progress_label'
        bind_template_child 'import_media_option'
        bind_template_child 'grid_2'
        bind_template_child 'media_name_label'
      end
    end

    def initialize(application)
      super(application: application)
      set_title "Banshy!"
      @video_screen = Banshy::VideoScreen.new
      @media_display = MediaListDisplay.new
      @buffer = nil
      grid_2.attach @media_display, 1, 0, 1, 1
      set_progress_control
      init_behaviors
      set_time_label
      show_all
    end

    def menu_bar_behavior
      import_media_option.signal_connect 'activate' do
        ImportMediaWindow.new
      end
    end

    def set_time_label
      time_label.text = '00:00:00'
      progress_label.text = '00:00:00'
    end

    def init_behaviors
      play_behavior
      pause_behavior
      progress_control_behavior
      menu_bar_behavior
    end

    def play_behavior
      button_play.signal_connect 'clicked' do
        load_video_buffer
        if @buffer&.ready                              # Safe navigation operator equals to
          @buffer.play                                 # @buffer && @buffer.ready
          @progress_control_handler.start_update_timer # Qué cosas mas modernas y que viejo estoy ya
        end
      end
    end

    def load_video_buffer
      unless @buffer&.file == @media_display.selected
        selected = @media_display.selected
        @buffer = @video_screen
        @buffer.load_video selected
        @progress_control_handler.init_buffer @buffer
        switch_to_screen
        media_name_label.text = @buffer.name
        time_label.text = @buffer.duration
      end
    end

    def switch_to_screen
      grid_2.remove @media_display
      grid_2.attach @video_screen, 1, 0, 1, 1
      show_all
    end

    def pause_behavior
      button_pause.signal_connect 'clicked' do
        @buffer.pause
        @progress_control_handler.stop_update_timer
      end
    end

    def progress_control_behavior
      was_playing = nil
      progress_control.signal_connect 'change-value' do
        was_playing ||= @buffer.is_playing?
        @buffer.pause if @buffer.is_playing?
      end

      progress_control.signal_connect_after 'change-value' do
        @buffer.play if was_playing
        @buffer.move_to_position progress_control.value
        was_playing = nil
      end
    end

    def set_progress_control
      @progress_control_handler = ProgressControlHandler.new(progress_label,
                                                             progress_adjustement)
    end

    private

    def time_format(seconds)
      [seconds / 3600, seconds / 60 % 60, seconds % 60].map{|t| t.to_s.rjust(2,'0')}.join(':')
    end
  end
end
