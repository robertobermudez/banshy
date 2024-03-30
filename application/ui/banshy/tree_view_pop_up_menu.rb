# frozen_string_literal: true
require 'pry-byebug'
module Banshy
  class TreeViewPopUpMenu < Gtk::Menu
    type_register
    class << self
      def init
        set_template resource: '/com/mordrec/banshy/ui/tree_view_pop_up_menu.ui'
        bind_template_child 'add_music_pl'
        bind_template_child 'delete_music_pl'
        bind_template_child 'add_video_pl'
        bind_template_child 'delete_video_pl'
      end
    end

    attr_reader :add_music_pl, :delete_music_pl, :add_video_pl, :delete_video_pl

    def initialize(parent)
      super()
      @parent = parent
      show_all
      signals
      music_playlist_names_to_delete if MusicPlaylist.count.positive?
      video_playlist_names_to_delete if VideoPlaylist.count.positive?
    end

    def music_playlist_names_to_delete
      menu = Gtk::Menu.new
      MusicPlaylist.pluck(:name).each do |name|
        pl = Gtk::MenuItem.new(label: name)
        menu.append pl
        pl.signal_connect 'activate' do
          MusicPlaylist.find_by(name: pl.label).destroy
          @parent.load_treestore
        end
      end
      delete_music_pl.submenu = menu
      menu.show_all
    end

    def video_playlist_names_to_delete
      menu = Gtk::Menu.new
      VideoPlaylist.pluck(:name).each do |name|
        pl = Gtk::MenuItem.new(label: name)
        menu.append pl
        pl.signal_connect 'activate' do
          VideoPlaylist.find_by(name: pl.label).destroy
          @parent.load_treestore
        end
      end
      delete_video_pl.submenu = menu
      menu.show_all
    end

    def signals
      add_music_pl_signals
      add_video_pl_signals
    end

    def add_music_pl_signals
      add_music_pl.signal_connect 'activate' do
        InputPlaylistDialog.new('music', @parent, self).present
      end
    end

    def add_video_pl_signals
      add_video_pl.signal_connect 'activate' do
        InputPlaylistDialog.new('video', @parent, self).present
      end
    end
  end
end
