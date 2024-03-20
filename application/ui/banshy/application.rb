module Banshy
  class Application < Gtk::Application
    def initialize
      super 'com.mordrec.banshy', Gio::ApplicationFlags::FLAGS_NONE

      signal_connect :activate do |application|
        window = Banshy::ApplicationWindow.new(application)
        window.present
      end
    end
  end
end
