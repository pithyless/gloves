$toolkit = :qt
require 'rui'

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
