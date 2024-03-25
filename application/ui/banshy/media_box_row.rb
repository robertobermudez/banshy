module Banshy
  class MediaBoxRow < Gtk::ListBoxRow
    type_register
    class << self
      def init
        set_template resource: '/com/mordrec/banshy/ui/media_box_row.ui'
        bind_template_child 'name_label'
        bind_template_child 'duration_label'
      end
    end

    attr_reader :media_item

    def initialize(media_item)
      super()
      @media_item = media_item
      name_label.text = @media_item.name
      duration_label.text = @media_item.duration
    end
  end
end
