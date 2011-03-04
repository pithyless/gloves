require_relative 'chunkiness'

class ImageFileNotFound < StandardError; end

class BaseLens
  include Chunkyable

  attr_reader :image

  def initialize(image)
    unless image.instance_of? Qt::Image
      raise "Lens.initialize expected Qt::Image, not #{image.class}"
    end
    @image = image
  end
end

class ScanLens < BaseLens
  def initialize(filename)
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
    ColorLens.new(new_img)
  end
end

class ColorLens < BaseLens
  def to_gray_lens
    new_img = modify_each_pixel_chunky do |px|
      c = Colour.from_chunky(px)
      g = GrayColour.from_colour(c)
      g.to_chunky
    end
    GrayLens.new(new_img)
  end
end

class GrayLens < BaseLens
  def c_background
    Colour.rgba(0, 255, 255, 255)
  end

  def c_outer_line_border
    Colour.rgba(255, 0, 0, 255)
  end

  def c_inner_line
    Colour.rgba(0, 0, 255, 255)
  end

  def c_inner_line_border
    Colour.rgba(0, 255, 0, 255)
  end

  def c_inner_region
    Colour.rgba(255, 255, 0, 255)
  end

  def to_outline_lens
    new_img = using_chunky do |img|

      # fill in background
      queue = [[0,0]]
      until queue.empty?
        x,y = queue.pop
        c = Colour.from_chunky(img[x,y])
        if c.invisible?
          img[x,y] = c_background.to_chunky
          [[x-1,y-1], [x,y-1], [x+1,y-1],
           [x-1,y],            [x+1,y],
           [x-1,y+1], [x,y+1], [x+1,y+1]].each do |xx,yy|
            if xx < img.width and xx >= 0 and
                yy < img.height and yy >= 0
              queue.push([xx,yy])
            end
          end
        end
      end

      # fill in inner regions
      for y in 0...img.height do
        for x in 0...img.width do
          c = Colour.from_chunky(img[x,y])
          if c.invisible?
            img[x,y] = c_inner_region.to_chunky
          end
        end
      end
    end
    OutlineLens.new(new_img)
  end
end

class OutlineLens < BaseLens
end
