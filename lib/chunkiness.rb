require 'oily_png' # oily_png is faster chunky_png
require_relative 'colour'

module Chuckable
  #
  # Takes a QImage, converts to ChunkyPNG,
  # applies block to ChunkyPNG, then returns new QImage
  #
  def using_chunky
    ba = Qt::ByteArray.new
    iob = Qt::Buffer.new(ba)
    iob.open(Qt::IODevice::ReadWrite)
    @image.save(iob, "PNG")

    iob.reset
    img = ChunkyPNG::Image.from_blob(iob.readAll.data)
    iob.close

    yield img
    len = img.width * img.height
    Qt::Image.fromData(img.to_datastream.to_blob, len)
  end

  #
  # Iterates over ChunkyPNG and applies function to each pixel;
  # where function expects Colour and returns Colour
  #
  def modify_each_pixel_chunky
    using_chunky do |img|
      for y in 0...img.height do
        for x in 0...img.width do
          img[x,y] = yield(img[x,y])
        end
      end
    end
  end
end

class ScanMonocle
  include Chuckable
end

Colour.class_eval do
  def self.from_chunky(col)
    (r,g,b,a) = ChunkyPNG::Color.to_truecolor_alpha_bytes(col)
    Colour.rgba(r, g, b, a)
  end

  def to_chunky
    ChunkyPNG::Color.rgba(red, green, blue, alpha)
  end
end

GrayColour.class_eval do
  def self.from_chunky(col)
    (r,g,b,a) = ChunkyPNG::Color.to_truecolor_alpha_bytes(col)
    unless (r == g and r == b)
      raise ColourMismatch.new("Does not look like gray pixel!")
    end
    GrayColour.gray(r, a)
  end

  def to_chunky
    ChunkyPNG::Color.rgba(gray, gray, gray, alpha)
  end
end

