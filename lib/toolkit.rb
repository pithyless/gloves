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
  def initialize(graphics_view)
    super(Qt::RubberBand::Rectangle, graphics_view)
    @initial_pos = Qt::Point.new(0,0)
    @final_pos   = @initial_pos

    pen = Qt::Pen.new
    pen.color = Qt::Color.new(50,50,50,130)
    pen.style = Qt::DotLine
    pen.width = 2
    @my_pen = pen
  end

  def paintEvent(event)
    painter = Qt::Painter.new(self)
    painter.pen = @my_pen

    painter.brush = Qt::Brush.new(Qt::Color.new(50,50,50,100))
    painter.drawRect(event.rect)
    painter.end
  end

  def select_rect
    Qt::Rect.new(@initial_pos, @final_pos).normalized
  end

  def start_select(pos)
    @initial_pos = pos
    @final_pos   = pos
    setGeometry(select_rect)
    show
  end

  def update_select(pos)
    @final_pos = pos
    setGeometry(select_rect)
  end

  def finish_select(pos)
    @final_pos = pos
    setGeometry(select_rect)
  end
end

class MonocleSelectorWidget < Qt::Widget
  def initialize(parent = nil, graphics_view)
    super(parent)
    setPalette(Qt::Palette.new(Qt::Color.new(0, 0, 0, 0)))
    setAutoFillBackground(true)
    @graphics_view = graphics_view
  end

  def rubber_band
    @rubber_band ||= RubberBandSelect.new(@graphics_view)
  end

  def mousePressEvent(event)
    rubber_band.start_select(event.globalPos)
  end

  def mouseMoveEvent(event)
    rubber_band.update_select(event.globalPos)
  end

  def mouseReleaseEvent(event)
    rubber_band.finish_select(event.globalPos)

    # TODO: temporary
    if not @once_only
      @once_only = true
      p @graphics_view.scene.items

      tmp_pixmap = @graphics_view.scene.items[1].pixmap
      tmp_pixmap = tmp_pixmap.copy(rubber_band.select_rect)
      p 'Creating new pixmap scene!'
      @graphics_view.scene.addPixmap(tmp_pixmap)
    end
  end
end

# module RUI
#   module GuiBuilder
#     class MonocleSelector
#       include GuiBuilder

#       def create_element(window, parent, desc)
#         #
#         # NOTE: Qt::GraphicsProxyWidget must be top-level;
#         #       do not pass in any parent:
#         # NO: label = Qt::Label.new('test', window)
#         # YES:label = Qt::Label.new('test')
#         #

#         #(nil, desc.opts[:graphics_view])
#         raise parent.to_s
#         sel = MonocleSelectorWidget.new
#         setup_widget(sel, window, parent, desc)
#         sel
#       end
#     end
#   end
# end


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
