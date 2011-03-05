require 'oily_png' # oily_png is faster chunky_png

module Chunkyable
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
  # Takes a QImage, converts to ChunkyPNG,
  # then applies block to ChunkyPNG
  #
  def map_chunky
    ba = Qt::ByteArray.new
    iob = Qt::Buffer.new(ba)
    iob.open(Qt::IODevice::ReadWrite)
    @image.save(iob, "PNG")

    iob.reset
    img = ChunkyPNG::Image.from_blob(iob.readAll.data)
    iob.close

    yield img
  end

  #
  # Iterates over ChunkyPNG
  #
  def each_pixel_chunky
    map_chunky do |img|
      for y in 0...img.height do
        for x in 0...img.width do
          yield(img[x,y])
        end
      end
    end
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

  def each_surrounding_coordinate(x,y)
    maxheight = @image.height
    maxwidth  = @image.width
    [[x-1,y-1], [x,y-1], [x+1,y-1],
     [x-1,y],            [x+1,y],
     [x-1,y+1], [x,y+1], [x+1,y+1]].each do |xx,yy|
      next if yy < 0 or yy >= maxheight
      next if xx < 0 or xx >= maxwidth
      yield [xx,yy]
    end
  end
end
