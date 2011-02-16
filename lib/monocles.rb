require_relative 'images'

class ScanMonocle
  attr_reader :image

  def initialize(filename)
    @filename = filename
    @image = Qt::Image.new(filename)
  end

  def to_gray_monocle
    to_gray_monocle_chunky
    length = @image.width * @image.height
    gray = Qt::Image.fromData(@image_datastream, length)
    GrayMonocle.new(gray)
  end

end

class GrayMonocle
  attr_reader :image

  def initialize(image)
    @image = image
  end
end


# class AlphaMonocle
# end


