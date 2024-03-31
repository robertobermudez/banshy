module Banshy
  class MediaListDisplay < Gtk::ScrolledWindow
    type_register
    class << self
      def init
        set_template resource: '/com/mordrec/banshy/ui/media_list_display.ui'
        bind_template_child 'media_list_box'
      end
    end

    attr_reader :selected, :queue, :selected_row, :search_entry

    def initialize(search_entry)
      super()
      load_videos
      select_handler
      init_popup_menu
      @search_entry = search_entry
      @video_queue = []
      @music_queue = []
      search_handler
    end

    def load_files(keep_query = true, &block)
      clean_display
      @current_query = yield if keep_query
      yield.find_each(batch_size: 50).with_index do |file, index|
        media_list_box.add MediaBoxRow.new(file, index)
      end
    end

    def load_videos
      load_files { VideoFile.all }
    end

    def select_previous
      if @selected_row
        pos = media_list_box.children.index @selected_row
        if pos > 0
          media_list_box.select_row media_list_box.children[pos - 1]
        end
      end
    end

    def select_next_random
      if @selected_row
        prng = Random.new
        range = media_list_box.children.count
        media_list_box.select_row media_list_box.children[prng.rand(range)]
      end
    end

    def select_next
      if @selected_row
        pos = media_list_box.children.index @selected_row
        if pos < media_list_box.children.count
          media_list_box.select_row media_list_box.children[pos + 1]
        end
      end
    end

    def select_handler
      media_list_box.signal_connect('row-selected') do |widget, row|
        @selected = row&.media_item
        @selected_row = row
        selected&.reload
      end
    end

    def search_handler
      @search_entry.signal_connect 'search_changed' do
        if search_entry.text.length > 2
          load_files(false) do
            @current_query.where('name LIKE ?', "%#{search_entry.text}%")
          end
        end
      end
    end

    def init_popup_menu(another_widget = media_list_box)
      another_widget.add_events Gdk::EventMask::BUTTON_PRESS_MASK
      another_widget.signal_connect 'button_press_event' do |widget, event|
        if event.button == 3
          MediaBoxPopupMenu.new(selected_row, media_list_box, queue).popup(nil, nil, event.button, event.time) if selected
        end
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
