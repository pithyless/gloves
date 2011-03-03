require_relative 'chunkiness'

class ImageFileNotFound < StandardError; end

class ScanLens
  include Chunkyable

  attr_reader :image

  def initialize(attache, filename)
    @attache = attache
    @filename = filename
    if File.exists? filename
      @image = Qt::Image.new(filename)
    else
      raise ImageFileNotFound.new("#{filename}")
    end
  end

  def to_color_lens
    new_img = modify_each_pixel_chunky do |px|
      c = Colour.from_chunky(px)
      m = 250
      if c.red > m and c.green > m and c.blue > m
        c = Colour.invisible
      end
      c.to_chunky
    end
    ColorLens.new(@attache, new_img)
  end
end

class ColorLens
  include Chunkyable

  attr_reader :image

  def initialize(attache, image)
    @attache = attache
    @image = image
  end

  def to_gray_lens
    new_img = modify_each_pixel_chunky do |px|
      c = Colour.from_chunky(px)
      g = GrayColour.from_colour(c)
      g.to_chunky
    end
    GrayLens.new(@attache, new_img)
  end
end

class GrayLens
  include Chunkyable

  attr_reader :image

  def initialize(attache, image)
    @attache = attache
    @image = image
  end
end
