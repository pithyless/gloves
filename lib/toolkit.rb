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

class Qt::Image
  def to_image
    self
  end
end

Qt::Color.class_eval do
  def self.clasp_rgbF(r, g, b, a)
    vs = [r, g, b, a].collect! do |x|
      self.claspF(x)
    end
    self.fromRgbF(*vs)
  end

  private

  def self.claspF(value)
    return 1.0 if value > 1.0
    return 0.0 if value < 0.0
    value
  end
end
