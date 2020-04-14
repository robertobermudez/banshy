module Banshy
  class Application < Gtk::Application
    def initialize
      super 'com.mordrec.banshy', Gio::ApplicationFlags::FLAGS_NONE

      signal_connect :activate do |application|
        window = Gtk::ApplicationWindow.new(application)
        window.set_title 'Banshy!'
        window.present
      end
    end
  end
end
