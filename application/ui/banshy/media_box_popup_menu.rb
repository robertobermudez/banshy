module Banshy
  class MediaBoxPopupMenu < Gtk::Menu
    type_register
    class << self
      def init
        set_template resource: '/com/mordrec/banshy/ui/media_box_popup_menu.ui'
        bind_template_child 'add_to_playlist'
        bind_template_child 'remove_from_playlist'
        bind_template_child 'add_to_favourites'
        bind_template_child 'remove_from_favourites'
        bind_template_child 'remove_from_db'
      end
    end

    attr_reader :file, :row, :list_display

    def initialize(row, list_display, queue)
      super()
      @row = row
      @list_display = list_display
      @file = row.media_item
      fill_add_to_playlist
      fill_remove_from_playlist
      signals
    end

    def fill_add_to_playlist
      menu = Gtk::Menu.new
      if file.is_a?(MusicFile) && MusicPlaylist.all.any?
        fill_add_to_music_playlist menu
      elsif file.is_a?(VideoFile) && VideoPlaylist.all.any?
        fill_add_to_video_playlist menu
      end
      unless menu.children.empty?
        add_to_playlist.submenu = menu
        menu.show_all
      end
    end

    def fill_remove_from_playlist
      menu = Gtk::Menu.new
      if file.is_a?(MusicFile) && file.music_playlists.any?
        fill_remove_from_music_playlist menu
      elsif file.is_a?(VideoFile) && file.video_playlists.any?
        fill_remove_from_video_playlist menu
      end
      unless menu.children.empty?
        remove_from_playlist.submenu = menu
        menu.show_all
      end
    end

    def signals
      signal_add_to_favourites
      signal_remove_from_favourites
      signal_remove_from_db
    end

    def signal_remove_from_db
      remove_from_db.signal_connect 'activate' do
        file.destroy
        list_display.remove row
      end
    end

    def signal_add_to_favourites
      add_to_favourites.signal_connect 'activate' do
        file.update(favourite: true) unless file.favourite
      end
    end

    def signal_remove_from_favourites
      remove_from_favourites.signal_connect 'activate' do
        file.update(favourite: true) if file.favourite
      end
    end

    def fill_remove_from_video_playlist(menu)
      file.video_playlists.each do |video_pl|
        pl = Gtk::MenuItem.new(label: video_pl.name)
        menu.append pl
        pl.signal_connect 'activate' do
          VideoPlaylist.find_by(name: pl.label).video_files.delete file
          file.reload
          video_pl.reload
        end
      end
    end

    def fill_remove_from_music_playlist(menu)
      file.music_playlists.each do |music_pl|
        pl = Gtk::MenuItem.new(label: music_pl.name)
        menu.append pl
        pl.signal_connect 'activate' do
          MusicPlaylist.find_by(name: pl.label).music_files.delete file
          file.reload
          music_pl.reload
        end
      end
    end

    def fill_add_to_music_playlist(menu)
      MusicPlaylist.all.each do |music_pl|
        next if music_pl.music_files.include? file

        pl = Gtk::MenuItem.new(label: music_pl.name)
        menu.append pl
        pl.signal_connect 'activate' do
          MusicPlaylist.find_by(name: pl.label).music_files << file
        end
      end
    end

    def fill_add_to_video_playlist(menu)
      VideoPlaylist.all.each do |video_pl|
        next if video_pl.video_files.include? file

        pl = Gtk::MenuItem.new(label: video_pl.name)
        menu.append pl
        pl.signal_connect 'activate' do
          VideoPlaylist.find_by(name: pl.label).video_files << file
        end
      end
    end
  end
end
