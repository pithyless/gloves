class ScanMonocle
  attr_reader :image

  def initialize(filename)
    @image = Qt::Image.new(filename)
  end
end

# class AlphaMonocle
# end

# class GrayMonocle
# end

