module Banshy
  class MediaListDisplay < Gtk::ScrolledWindow
    type_register
    class << self
      def init
        set_template resource: '/com/mordrec/banshy/ui/media_list_display.ui'
        bind_template_child 'media_list_box'
      end
    end

    attr_reader :selected

    def initialize
      super()
      load_videos
      select_handler
    end

    def load_videos
      clean_display
      VideoFile.all.each do |file|
        media_list_box.add MediaBoxRow.new(file)
      end
    end

    def load_music
      clean_display
      MusicFile.all.each do |file|
        media_list_box.add MediaBoxRow.new(file)
      end
    end

    def select_handler
      media_list_box.signal_connect('row-selected') do |widget, row|
        @selected = row&.media_item
      end
    end

    private

    def clean_display
      media_list_box.unselect_all
      @selected = nil
      media_list_box.children.each { |child| media_list_box.remove child }
    end
  end
end
