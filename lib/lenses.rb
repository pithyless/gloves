require_relative 'chunkiness'
require_relative 'kolor'

class ImageFileNotFound < StandardError; end

class BaseLens
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
    unless File.exists? filename
      raise ImageFileNotFound.new "#{filename}"
    end
    @filename = filename
    super(Qt::Image.new(filename))
  end

  def to_color_lens
    m = 250 # max threshold
    new_img = @image.new_image_using_chunky do |chunky_img|
      chunky_img.map_pixels! do |px|
        if Kolor.red(px) > m and Kolor.green(px) > m and
            Kolor.blue(px) > m
          px = Kolor.invisible
        end
        px
      end
    end
    ColorLens.new(new_img)
  end
end

class ColorLens < BaseLens
  def to_gray_lens
    new_img = @image.new_image_using_chunky do |chunky_img|
      chunky_img.map_pixels! do |px|
        Kolor.to_grayscale(px)
      end
    end
    GrayLens.new(new_img)
  end
end

class GrayLens < BaseLens

  def to_outline_lens
    c_background_chunky = OutlineLens::C_BACKGROUND
    c_outer_line_border_chunky = OutlineLens::C_OUTER_LINE_BORDER
    c_inner_line_border_chunky = OutlineLens::C_INNER_LINE_BORDER
    c_inner_region_chunky = OutlineLens::C_INNER_REGION
    c_inner_stroke_chunky = OutlineLens::C_INNER_STROKE

    c_invisible_chunky = Kolor.invisible

    new_img = @image.new_image_using_chunky do |img|

      # fill in background
      queue = [[0,0]]    # todo: assumes [0,0] is background pixel
      until queue.empty?
        x,y = queue.pop
        if img[x,y] == c_invisible_chunky
          img[x,y] = c_background_chunky
          img.each_surrounding_coordinate(x,y) do |xx, yy|
            queue.push([xx,yy])
          end
        elsif Kolor.gray?(img[x,y])
          img[x,y] = c_outer_line_border_chunky
        end
      end

      # fill in inner regions
      for y in 0...img.height do
        for x in 0...img.width do
          next unless c_invisible_chunky == img[x,y]
          img[x,y] = c_inner_region_chunky
          img.each_surrounding_coordinate(x,y) do |xx, yy|
            if Kolor.gray?(img[xx,yy])
              img[xx,yy] = c_inner_line_border_chunky
            end
          end
        end
      end

      # color inner strokes
      img.map_pixels! do |px|
        Kolor.gray?(px) ? c_inner_stroke_chunky : px
      end

    end
    OutlineLens.new(new_img)
  end
end

class OutlineLens < BaseLens
  C_BACKGROUND = Kolor.rgba(0, 255, 255, 255)
  C_OUTER_LINE_BORDER = Kolor.rgba(255, 0, 0, 255)
  C_INNER_LINE_BORDER = Kolor.rgba(0, 0, 255, 255)
  C_INNER_REGION = Kolor.rgba(255, 255, 0, 255)
  C_INNER_STROKE = Kolor.rgba(0, 255, 0, 255)
end
