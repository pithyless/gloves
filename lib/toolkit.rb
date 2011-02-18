$toolkit = :qt
require 'rui'

class Qt::ScrollArea
  def add_widget(widget)
    self.widget = widget
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
  def deep_copy
    copy(0, 0, width, height)
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

class RubberBandSelect < Qt::RubberBand
  def paintEvent(event)
    painter = Qt::Painter.new(self)
    painter.setBrush(Qt::Brush.new(Qt::blue))
    painter.drawRect(event.rect)
    painter.end
  end
end

class MonocleSelectorWidget < Qt::Widget
  def initialize(parent = nil, graphics_view)
    super(parent)
    # setPalette(Qt::Palette.new(Qt::Color.new(0, 0, 0, 0)))
    # setAutoFillBackground(true)
    @graphics_view = graphics_view
  end

  # TODO
  # def paintEvent(event)
  #   painter = Qt::Painter.new(self)
  #   painter.setBrush(Qt::Brush.new(Qt::blue))
  #   painter.drawRect(Qt::Rect.new(30, 30, 50, 50))
  #   painter.end
  # end

  def rubberBand
    @rubberBand = @rubberBand ||
      RubberBandSelect.new(Qt::RubberBand::Rectangle, @graphics_view)
  end

  def mousePressEvent(event)
    @mouse_origin = event.globalPos
    rubberBand.setGeometry(Qt::Rect.new(@mouse_origin,
                                        Qt::Size.new(0,0)))
    rubberBand.show
  end

  def mouseMoveEvent(event)
    rubberBand.setGeometry(Qt::Rect.new(@mouse_origin,
                                        event.globalPos).normalized)
  end

  def mouseReleaseEvent(event)
    p Qt::Rect.new(@mouse_origin,event.globalPos).normalized
  end
end

module RUI
  module GuiBuilder
    class MonocleSelector
      include GuiBuilder

      def create_element(window, parent, desc)
        #
        # NOTE: Qt::GraphicsProxyWidget must be top-level;
        #       do not pass in any parent:
        # NO: label = Qt::Label.new('test', window)
        # YES:label = Qt::Label.new('test')
        #

        #(nil, desc.opts[:graphics_view])
        sel = MonocleSelectorWidget.new
        setup_widget(sel, window, parent, desc)
        sel
      end
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
