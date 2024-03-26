module Banshy
  class MediaTreeView < Gtk::ScrolledWindow
    type_register
    class << self
      def init
        set_template resource: '/com/mordrec/banshy/ui/media_tree_view.ui'
        bind_template_child 'tree_view'
        bind_template_child 'tree_selection' # TreeSelection
        bind_template_child 'tree_store' # TreeStore
        bind_template_child 'options_col' # Column 1
        bind_template_child 'cr_options' # CellRenderer
      end
    end

    TREE_MENU = ['Playing now',
       'Play queue',
       'Video',
       'Video playlists',
       'Music',
       'Music playlists']

    attr_reader :parent

    def initialize(parent)
      @parent = parent
      super()
      TREE_MENU.each do |item|
        root_iter = tree_store.append(nil)
        root_iter[0] = item
      end
      tree_view.model = tree_store
      double_click_handler
    end

    def double_click_handler
      tree_view.signal_connect 'row-activated' do |view, path, column|
        parent.pause_behavior
        parent.switch_to_display
        case path.to_s
        when '2', '3' then parent.media_display.load_videos
        when '4', '5' then parent.media_display.load_music
        end
      end
    end
  end
end
