module Banshy
  class ApplicationWindow < Gtk::ApplicationWindow
    type_register
    class << self
      def init
        set_template resource: '/com/mordrec/banshy/ui/application_window.ui'
        bind_template_child 'button_play'
        bind_template_child 'button_pause'
        bind_template_child 'button_previous'
        bind_template_child 'button_next'
        bind_template_child 'progress_control'
        bind_template_child 'progress_adjustement'
        bind_template_child 'time_label'
        bind_template_child 'progress_label'
        bind_template_child 'import_media_option'
        bind_template_child 'open_file_option'
        bind_template_child 'grid_2'
        bind_template_child 'media_name_label'
        bind_template_child 'volume_control'
        bind_template_child 'sequential_next'
        bind_template_child 'random_next'
        bind_template_child 'automatic_forward'
        bind_template_child 'media_search'
        bind_template_child 'quit_option'
      end
    end

    attr_reader :buffer, :screen_active, :media_display

    def initialize(application)
      super(application: application)
      set_title 'Banshy!'
      @screen_active = false
      @random_forward = false
      attach_components
      set_progress_control
      init_handlers
      set_time_label
      show_all
    end

    def attach_components
      @tree_view = MediaTreeView.new self
      @media_display = MediaListDisplay.new(media_search)
      @buffer = Banshy::MediaPlayer.new @media_display
      @automatic_forwarder = AutomaticForwarder.new(self, buffer)
      grid_2.attach @tree_view, 0, 0, 1, 1
      grid_2.attach @media_display, 1, 0, 1, 1
    end

    def set_progress_control
      @progress_control_handler = ProgressControlHandler.new(progress_label,
                                                             progress_adjustement)
    end

    def init_handlers
      play_handler
      pause_handler
      next_handler
      previous_handler
      progress_control_behavior
      menu_bar_handler
      volume_handler
      random_forward_handler
      automatic_forward_handler
      close_app
    end

    def automatic_forward_handler
      automatic_forward.signal_connect 'toggled' do |button|
        if button.active?
          @automatic_forwarder.start
        else
          @automatic_forwarder.stop
        end
      end
    end

    def random_forward_handler
      random_next.signal_connect 'toggled' do |button|
        @random_forward = button.active?
      end
    end

    def set_time_label
      time_label.text = '00:00:00'
      progress_label.text = '00:00:00'
    end

    def menu_bar_handler
      import_media_option.signal_connect 'activate' do
        ImportMediaWindow.new
      end
      open_file_option.signal_connect 'activate' do
        OpenFileDialog.new
      end
    end

    def play_behavior
      load_buffer selected if selected && selected != buffer&.file
      if @buffer&.ready?
        switch_to_screen                             # Safe navigation operator equals to
        @buffer.play                                 # @buffer && @buffer.ready
        @progress_control_handler.start_update_timer # Qué cosas mas modernas y que viejo estoy ya
      end
    end

    def load_buffer(file)
      @buffer.load file
      @progress_control_handler.init_buffer @buffer
      media_name_label.text = @buffer.name
      time_label.text = @buffer.duration
    end

    def switch_to_display
      if screen_active
        grid_2.remove @buffer
        grid_2.attach @media_display, 1, 0, 1, 1
        @screen_active = false
        show_all
      end
    end

    def switch_to_screen
      unless screen_active || @buffer.playing_music?
        grid_2.remove @media_display
        grid_2.attach @buffer, 1, 0, 1, 1
        @screen_active = true
        show_all
      end
    end

    def selected
      @media_display.selected
    end

    def pause_behavior
      @buffer.pause
      @progress_control_handler.stop_update_timer
    end

    def play_handler
      button_play.signal_connect 'clicked' do
        play_behavior
      end
    end

    def pause_handler
      button_pause.signal_connect 'clicked' do
        pause_behavior
      end
    end

    def previous_handler
      button_previous.signal_connect 'clicked' do
        @media_display.select_previous
        play_behavior if @buffer.is_playing?
      end
    end

    def next_handler
      button_next.signal_connect 'clicked' do
        next_behavior
      end
    end

    def next_behavior
      if @random_forward
        @media_display.select_next_random
      else
        @media_display.select_next
      end
      play_behavior if @buffer.is_playing?
    end

    def volume_handler
      volume_control.signal_connect 'value-changed' do
        @buffer.set_volume volume_control.value if @buffer.is_playing?
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

    def close_app
      quit_option.signal_connect 'select' do
        exit
      end
    end

    private

    def time_format(seconds)
      [seconds / 3600, seconds / 60 % 60, seconds % 60].map{|t| t.to_s.rjust(2,'0')}.join(':')
    end
  end
end
