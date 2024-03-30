module Banshy
  class MediaBoxRow < Gtk::ListBoxRow
    type_register
    class << self
      def init
        set_template resource: '/com/mordrec/banshy/ui/media_box_row.ui'
        bind_template_child 'name_label'
        bind_template_child 'duration_label'
        bind_template_child 'event_box'
      end
    end

    attr_reader :media_item, :pos

    def initialize(media_item, pos)
      super()
      @media_item = media_item
      name_label.text = @media_item.name
      duration_label.text = @media_item.duration
      @pos = pos
    end
  end
end
