module Banshy
  class InputPlaylistDialog < Gtk::Dialog
    type_register
    class << self
      def init
        set_template resource: '/com/mordrec/banshy/ui/input_playlist_dialog.ui'
        bind_template_child 'entry_name'
        bind_template_child 'type_label'
        bind_template_child 'accept_button'
        bind_template_child 'cancel_button'
      end
    end

    attr_reader :tree_view, :popup_menu

    def initialize(type, tree_view, popup_menu)
      super()
      @type = type
      @tree_view = tree_view
      @popup_menu = popup_menu
      set_label
      signals
    end

    def set_label
      type_label.text = "Input #{@type} playlist name"
    end

    def signals
      accept_button.signal_connect 'clicked' do
        create_playlist(entry_name.text)
        close
      end
      cancel_button.signal_connect 'clicked' do
        close
      end
    end

    def create_playlist(name)
      if @type == 'music'
        MusicPlaylist.new(name: name).save
        popup_menu.music_playlist_names_to_delete
      elsif @type == 'video'
        VideoPlaylist.new(name: name).save
        popup_menu.video_playlist_names_to_delete
      end
      tree_view.load_treestore
    end
  end
end
