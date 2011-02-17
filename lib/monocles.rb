require_relative 'chunkiness'

class ScanMonocle
  attr_reader :image

  def initialize(filename)
    @filename = filename
    @image = Qt::Image.new(filename)
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
  attr_reader :image

  def initialize(image)
    @image = image
  end
end


