require_relative 'chunkiness'

class ScanMonocle
  include Chuckable

  attr_reader :image

  def initialize(filename)
    @filename = filename
    @image = Qt::Image.new(filename)
  end

  def to_color_monocle
    color = modify_each_pixel_chunky do |px|
      c = Colour.from_chunky(px)
      m = 250
      if c.red > m and c.green > m and c.blue > m
        c = Colour.invisible
      end
      c.to_chunky
    end
    ColorMonocle.new(color)
  end
end

class ColorMonocle
  include Chuckable

  attr_reader :image

  def initialize(image)
    @image = image
  end

  def to_gray_monocle
    gray = modify_each_pixel_chunky do |px|
      c = Colour.from_chunky(px)
      g = GrayColour.from_colour(c)
      g.to_chunky
    end
    GrayMonocle.new(gray)
  end
end

class GrayMonocle
  include Chuckable

  attr_reader :image

  def initialize(image)
    @image = image
  end
end
