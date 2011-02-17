module Claspable
  private

  def clasp(value)
    value = value.to_i
    return 255 if value > 255
    return 0 if value < 0
    value
  end
end


class ColourMismatch < StandardError; end

#
# An abstract Colour RGBA class
#
class Colour
  include Claspable

  attr_reader :red, :blue, :green, :alpha
  #
  # Expects values in range 0..255
  #
  def self.rgba(r, g, b, a)
    c = Colour.new
    c.red = r
    c.green = g
    c.blue = b
    c.alpha = a
    c
  end

  def red=(x);   @red = clasp(x);   end
  def green=(x); @green = clasp(x); end
  def blue=(x);  @blue = clasp(x);  end
  def alpha=(x); @alpha = clasp(x); end
  
  def to_s
    "<Colour: #{red}, #{blue}, #{green}, #{alpha}>"
  end
end

class GrayColour
  include Claspable

  attr_reader :gray, :alpha

  def gray=(x);  @gray = clasp(x);  end
  def alpha=(x); @alpha = clasp(x); end
  
  def self.gray(gray, alpha)
    g = GrayColour.new
    g.gray = gray
    g.alpha = alpha
    g
  end

  def self.from_colour(col)
    gray = (0.3*col.red + 0.59*col.green + 0.11*col.blue).to_i
    GrayColour.gray(gray, col.alpha)
  end

  def to_s
    "<GrayColour: #{gray}, #{alpha}>"
  end
end
