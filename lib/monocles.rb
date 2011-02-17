require_relative 'coloring'

class ScanMonocle
  attr_reader :image

  def initialize(filename)
    @filename = filename
    @image = Qt::Image.new(filename)
  end

  def to_gray_monocle
    gray = using_chunky {|img| to_gray_monocle_chunky img }
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


