require 'oily_png' # oily_png is faster chunky_png
require_relative 'toolkit'

class Qt::Image
  #
  # Converts Qt::Image to ChunkyPNG,
  # applies block to ChunkyPNG, then returns new QImage
  #
  def new_image_using_chunky(&blk)
    img = to_chunky_image
    blk.call(img)
    len = img.width * img.height
    Qt::Image.fromData(img.to_datastream.to_blob, len)
  end

  #
  # Converts Qt::Image to ChunkyPNG
  #
  def to_chunky_image
    iob = Qt::Buffer.new(Qt::ByteArray.new)
    iob.open(Qt::IODevice::ReadWrite)
    save(iob, "PNG")
    iob.reset
    img = ChunkyPNG::Image.from_blob(iob.readAll.data)
    iob.close
    iob = nil
    img
  end
end

class ChunkyPNG::Image
  #
  # Iterates over ChunkyPNG and yields each pixel to block
  #
  def map_pixels(&blk)
    for y in 0...height do
      for x in 0...width do
        blk.call(self[x,y])
      end
    end
  end

  #
  # Iterates over ChunkyPNG and yields each pixel to block;
  # Block must return new pixel.
  #
  def map_pixels!(&blk)
    for y in 0...height do
      for x in 0...width do
        self[x,y] = blk.call(self[x,y])
      end
    end
  end

  def each_surrounding_coordinate(x,y)
    [[x-1,y-1], [x,y-1], [x+1,y-1],
     [x-1,y],            [x+1,y],
     [x-1,y+1], [x,y+1], [x+1,y+1]].each do |xx, yy|
      next unless include_xy?(xx, yy)
      yield [xx, yy]
    end
  end
end
