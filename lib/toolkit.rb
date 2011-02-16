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

  #
  # Iterates over RGB Image and applies function to each pixel;
  # where function expects Qt::Color and returns new Qt::Color
  #
  def modify_each_pixel_rgb
    # todo: raise Exception if Qt::Image is not RGB32
    # if image.format() != QImage.Format_RGB32:
    # raise ImageFormatError('modify_pixels_rgb needs RGB32,
    # not %s' % image.format())
    (0...height).each do |j|
      (0...width).each do |i|
        col = Qt::Color.new()
        col = Qt::Color.new(self.pixel(100,100))
        throw col.pretty
        # elf.pixel(i,j))
        new_col = yield(col)
        self.setPixel(i, j, new_col.rgb)
      end
    end
  end
end

Qt::Color.class_eval do
  def self.clasp_rgb_float(r, g, b, a)
    vs = [r, g, b, a].collect do |x|
      self.clasp_float(x)
    end
    self.fromRgbF(*vs)
  end

  def self.clasp_rgb(r, g, b, a)
    vs = [r, g, b, a].collect do |x|
      self.clasp(x)
    end
    self.fromRgb(*vs)
  end

  def pretty
    "<#{red}, #{blue}, #{green}, #{alpha}>"
  end
  
  private

  def self.clasp(value)
    value = value.to_i
    return 255 if value > 255
    return 0 if value < 0
    value
  end

  def self.clasp_float(value)
    value = value.to_f
    return 1.0 if value > 1.0
    return 0.0 if value < 0.0
    value
  end
end
