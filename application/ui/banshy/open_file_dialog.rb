module Banshy
  class OpenFileDialog
    attr_reader :dialog, :filter_video, :filter_music, :filter_all
    def initialize
      @dialog = Gtk::FileChooserDialog.new(title: 'Choose the file/s to be open',
                                           action: :open,
                                           select_multiple: true,
                                           buttons: [[Gtk::Stock::OPEN, :accept],
                                                     [Gtk::Stock::CANCEL, :cancel]])

      video_filters = ['*.mp4', '*.avi', '*.wmv', '*.ogg', '*.webm']
      music_filters = ['*.mp3']
      all_filters = video_filters + music_filters

      @dialog.select_multiple = true
      filter_video = Gtk::FileFilter.new
      filter_video.name = 'Video'

      filter_music = Gtk::FileFilter.new
      filter_music.name = 'Music'

      filter_all = Gtk::FileFilter.new
      filter_all.name = 'All'

      all_filters.each { |filter| filter_all.add_pattern filter }
      music_filters.each { |filter| filter_music.add_pattern filter }
      video_filters.each { |filter| filter_video.add_pattern filter }

      @dialog.add_filter filter_video
      @dialog.add_filter filter_music
      @dialog.add_filter filter_all

      if @dialog.run == Gtk::ResponseType::ACCEPT
        paths = dialog.filenames
        puts MediaImporter.import(paths,
                                  import_type: 'file')
        @dialog.close
      elsif @dialog.run == Gtk::ResponseType::CANCEL
        @dialog.close
      end
    end
  end
end
