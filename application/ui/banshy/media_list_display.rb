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
      @selected = nil
      select_handler
    end

    def load_videos
      media_list_box.children.each { |child| todo_items_list_box.remove child }
      VideoFile.all.each do |file|
        media_list_box.add MediaBoxRow.new(file)
      end
    end

    def select_handler
      media_list_box.signal_connect 'row-selected' do |widget, row|
        @selected = row.media_item
      end
    end
  end
end
