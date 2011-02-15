$toolkit = :qt
require 'rui'

RUI::GuiBuilder::Label.class_eval do
  def create_element(window, parent, desc)
    label = Qt::Label.new(desc.opts[:text].to_s, window)
    if desc.opts[:image]
      label.setPixmap desc.opts[:image].to_pix
    end
    setup_widget(label, window, parent, desc)
    if desc.opts[:buddy]
      window.buddies[label] = desc.opts[:buddy]
    end
    label
  end
end

class Qt::ScrollArea
  def add_widget(widget)
    setWidget(widget)
  end
end

module RUI::GuiBuilder
  class ScrollArea < Widget
    def factory(desc)
      Qt::ScrollArea
    end
  end
end
