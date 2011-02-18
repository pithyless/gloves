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

  def deep_copy
    copy(0, 0, width, height)
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

module RUI::GuiBuilder
  class GraphicsPixmapItem < Widget
    def factory(desc)
      Factory.new do |parent|
        Qt::GraphicsPixmapItem.new(desc.opts[:image].to_pix)
      end
    end
  end
end

class Qt::GraphicsScene
  def add_widget(widget)
    if widget.is_a?(Qt::GraphicsItem)
      addItem(widget)
    else
      # TODO: Better test for Qt::GraphicsProxyWidget?
      addWidget(widget)
    end
  end
end

module RUI::GuiBuilder
  class GraphicsScene < Widget
    def factory(desc)
      Qt::GraphicsScene
    end
  end
end

class Qt::GraphicsView
  def add_widget(scene)
    @scene = scene
    setScene(@scene)
  end
end

module RUI::GuiBuilder
  class GraphicsView < Widget
    def factory(desc)
      Qt::GraphicsView
    end
  end
end

class CanvasWidget < Qt::Widget
  def initialize(parent = nil)
    super
  end
  
  def paintEvent(event)
    painter = Qt::Painter.new(self)
    painter.setBrush(Qt::Brush.new(Qt::blue))
    painter.drawRect(Qt::Rect.new(30, 30, 50, 50))
    painter.end
  end
end

module RUI::GuiBuilder
  class CanvasArea < Widget
    def factory(desc)
      CanvasWidget
    end
  end
end


# Qt::Color.class_eval do
#   def self.clasp_rgb_float(r, g, b, a)
#     vs = [r, g, b, a].collect do |x|
#       self.clasp_float(x)
#     end
#     self.fromRgbF(*vs)
#   end

#   def self.clasp_float(value)
#     value = value.to_f
#     return 1.0 if value > 1.0
#     return 0.0 if value < 0.0
#     value
#   end
# end
