module Banshy
  class MediaTreeView < Gtk::ScrolledWindow
    type_register
    class << self
      def init
        set_template resource: '/com/mordrec/banshy/ui/media_tree_view.ui'
        bind_template_child 'tree_view'
        bind_template_child 'tree_selection' # TreeSelection
        bind_template_child 'options_col' # Column 1
        bind_template_child 'cr_options' # CellRenderer
      end
    end

    TREE_MENU = ['Play queue',
                 '',
                 'Video',
                 'Video Favourites',
                 'Video playlists',
                 '',
                 'Music',
                 'Music Favourites',
                 'Music playlists']

    attr_reader :parent, :popup_menu, :music_pl_col, :video_pl_col

    def initialize(parent)
      @parent = parent
      super()
      load_treestore
      double_click_handler
      init_popup_menu
    end

    def init_popup_menu
      tree_view.add_events Gdk::EventMask::BUTTON_PRESS_MASK
      tree_view.signal_connect 'button_press_event' do |widget, event|
        if event.button == 3
          TreeViewPopUpMenu.new(self).popup(nil, nil, event.button, event.time)
        end
      end
    end

    def load_treestore
      @music_pl_col = {}
      @video_pl_col = {}
      tree_store = Gtk::TreeStore.new(String)
      TREE_MENU.each do |item|
        root_iter = tree_store.append(nil)
        root_iter[0] = item
        if item == 'Video playlists'
          VideoPlaylist.all.each_with_index do |pl, index|
            child_iter = tree_store.append(root_iter)
            child_iter[0] = pl.name
            @video_pl_col[index.to_s] = pl.name
          end
        elsif item == 'Music playlists'
          MusicPlaylist.all.each_with_index do |pl, index|
            child_iter = tree_store.append(root_iter)
            child_iter[0] = pl.name
            @music_pl_col[index.to_s] = pl.name
          end
        end
      end
      tree_view.model = tree_store
      tree_view.show_all
    end

    def media_display
      parent.media_display
    end

    def double_click_handler
      tree_view.signal_connect 'row-activated' do |view, path, column|
        parent.pause_behavior
        parent.switch_to_display
        type_col, num_col = path.to_s.split(':')
        case type_col
        when '2'
          media_display.load_files { VideoFile.all }
        when '3'
          media_display.load_files { VideoFile.where(favourite: true) }
        when '4'
          if num_col
            media_display.load_files do
              VideoPlaylist.find_by(name: video_pl_col[num_col]).video_files
            end
          end
        when '6'
          media_display.load_files do
            MusicFile.all
          end
        when '7'
          media_display.load_files do
            MusicFile.where(favourite: true)
          end
        when '8'
          if num_col
            media_display.load_files do
              MusicPlaylist.find_by(name: music_pl_col[num_col]).music_files
            end
          end
        else
          media_display.load_files { VideoFile.all }
        end
      end
    end
  end
end
