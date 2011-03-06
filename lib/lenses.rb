require_relative 'chunkiness'
require_relative 'kolor'

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
    unless File.exists? filename
      raise ImageFileNotFound.new "#{filename}"
    end
    @filename = filename
    super(Qt::Image.new(filename))
  end

  def to_color_lens
    new_img = modify_each_pixel_chunky do |px|
      m = 250 # max threshold
      if Kolor.red(px) > m and Kolor.green(px) > m and
          Kolor.blue(px) > m
        px = Kolor.invisible
      end
      px
    end
    ColorLens.new(new_img)
  end
end

class ColorLens < BaseLens
  def to_gray_lens
    new_img = modify_each_pixel_chunky do |px|
      Kolor.to_grayscale(px)
    end
    GrayLens.new(new_img)
  end
end

class GrayLens < BaseLens

  def to_outline_lens
    c_background_chunky = Kolor.rgba(0, 255, 255, 255)
    c_outer_line_border_chunky = Kolor.rgba(255, 0, 0, 255)
    c_inner_region_chunky = Kolor.rgba(255, 255, 0, 255)
    c_inner_line_border_chunky = Kolor.rgba(0, 0, 255, 255)
    c_inner_stroke_chunky = Kolor.rgba(0, 255, 0, 255)

    c_invisible_chunky = Kolor.invisible

    new_img = using_chunky do |img|

      # fill in background
      queue = [[0,0]]    # todo: assumes [0,0] is background pixel
      until queue.empty?
        x,y = queue.pop
        if img[x,y] == c_invisible_chunky
          img[x,y] = c_background_chunky
          each_surrounding_coordinate(x,y) do |xx, yy|
            queue.push([xx,yy])
          end
        elsif Kolor.gray?(img[x,y])
          img[x,y] = c_outer_line_border_chunky
        end
      end

      # fill in inner regions
      for y in 0...img.height do
        row = img.row(y)
        row.each_with_index do |value, x|
          if Kolor.invisible?(value)
            row[x] = c_inner_region_chunky
            each_surrounding_coordinate(x,y) do |xx, yy|
              if Kolor.gray?(img[xx,yy])
                img[xx,yy] = c_inner_line_border_chunky
              end
            end
            img.replace_row!(y, row)
          end
        end
      end

      # color inner strokes
      (0...img.height).each do |y|
        row = img.row(y)
        row = row.map do |px|
          Kolor.gray?(px) ? c_inner_stroke_chunky : px
        end
        img.replace_row!(y, row)
      end

    end
    OutlineLens.new(new_img)
  end
end

class OutlineLens < BaseLens
end
