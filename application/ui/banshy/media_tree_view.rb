module Banshy
  class MediaTreeView < Gtk::ScrolledWindow
    type_register
    class << self
      def init
        set_template resource: '/com/mordrec/banshy/ui/media_tree_view.ui'
      end
    end
    def initialize
      super
    end
  end
end
