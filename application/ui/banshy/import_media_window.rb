module Banshy
  class ImportMediaWindow
    attr_reader :dialog, :options_box
    def initialize
      @dialog = Gtk::FileChooserDialog.new(title: 'Choose the folder/s to be imported',
                                           action: :select_folder,
                                           select_multiple: true,
                                           buttons: [[Gtk::Stock::OPEN, :accept],
                                                     [Gtk::Stock::CANCEL, :cancel]])

      @dialog.select_multiple = true
      @options_box = create_combo_box
      @dialog.extra_widget = @options_box
      if @dialog.run == Gtk::ResponseType::ACCEPT
        paths = dialog.filenames
        filter = @options_box.active_iter.get_value(0).downcase
        MediaImporter.import(paths,
                             import_type: 'folder',
                             filter: filter)
        @dialog.close
      elsif @dialog.run == Gtk::ResponseType::CANCEL
        @dialog.close
      end
    end

    def create_combo_box
      combo_box = Gtk::ComboBox.new(label: 'Media types')
      options = Gtk::ListStore.new(String)
      %w(All Video Music).each do |type|
        options.append[0] = type
      end
      renderer = Gtk::CellRendererText.new
      combo_box.pack_start(renderer, true)
      combo_box.set_attributes(renderer, 'text' => 0)
      combo_box.model = options
      combo_box.set_active 0
      combo_box
    end
  end
end
