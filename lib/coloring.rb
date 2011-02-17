require 'oily_png' # oily_png is faster chunky_png

module Chuckable
  #
  # Takes a QImage, converts to ChunkyPNG understandable,
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
end

class ScanMonocle
  include Chuckable

  private

  def to_gray_monocle_chunky(img)
    for y in 0...img.height do
      for x in 0...img.width do
        img[x, y] = color_to_gray(img[x,y])
      end
    end
  end

  def color_to_gray(col)
    # TODO: ignores alpha; is this OK?
    (r,g,b) = ChunkyPNG::Color.to_truecolor_bytes(col)
    gray = (0.3*r + 0.59*g + 0.11*b).to_i
    # TODO: clasp!
    ChunkyPNG::Color.rgba(gray, gray, gray, 255)
  end
end
