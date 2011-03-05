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
    @filename = filename
    if File.exists? filename
      @image = Qt::Image.new(filename)
    else
      raise ImageFileNotFound.new("#{filename}")
    end
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
      queue = [[0,0]]
      until queue.empty?
        x,y = queue.pop
        if img[x,y] == c_invisible_chunky
          img[x,y] = c_background_chunky
          [[x-1,y-1], [x,y-1], [x+1,y-1],
           [x-1,y],            [x+1,y],
           [x-1,y+1], [x,y+1], [x+1,y+1]].each do |xx,yy|
            if xx < img.width and xx >= 0 and
                yy < img.height and yy >= 0
              queue.push([xx,yy])
            end
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
            [[x-1,y-1], [x,y-1], [x+1,y-1],
             [x-1,y],            [x+1,y],
             [x-1,y+1], [x,y+1], [x+1,y+1]].each do |xx,yy|
              if xx < img.width and xx >= 0 and
                  yy < img.height and yy >= 0
                if Kolor.gray?(img[xx,yy])
                  img[xx,yy] = c_inner_line_border_chunky
                end
              end
            end
            img.replace_row!(y, row)
          end
        end
      end

      # color inner strokes
      for y in 0...img.height do
        for x in 0...img.width do
          if Kolor.gray?(img[x,y])
            img[x,y] = c_inner_stroke_chunky
          end
        end
      end

    end
    OutlineLens.new(new_img)
  end
end

class OutlineLens < BaseLens
end
