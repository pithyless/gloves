class KolorMismatch < StandardError; end

module Kolor
  extend ChunkyPNG::Color

  class << self
    alias_method :rgba_old, :rgba
    alias_method :red,   :r
    alias_method :green, :g
    alias_method :blue,  :b
    alias_method :alpha, :a
  end

  extend self

  def rgba(r, g, b, a)
    rgba_old(clasp(r), clasp(g), clasp(b), clasp(a))
  end

  def gray_alpha(gray, alpha)
    rgba(gray, gray, gray, alpha)
  end

  def invisible
    rgba(0, 0, 0, 0)
  end

  def invisible?(value)
    r(value) == 0 and g(value) == 0 and b(value) == 0 and
      a(value) == 0
  end

  def gray?(value)
    grayscale?(value) and not invisible?(value)
  end

  def assert_gray!(value)
    unless gray?(value)
      raise KolorMismatch.new("Kolor not grayscale! #{to_s(value)}")
    end
  end

  def gray(value)
    assert_gray!(value) # todo: should we test this?
    b(value)
  end

  def split(color)
    to_truecolor_alpha_bytes(color)
  end

  def split_gray(color)
    assert_gray!(color)
    to_grayscale_alpha_bytes(color)
  end

  def to_s(v)
    "<Kolor: #{red(v)}, #{blue(v)}, #{green(v)}, #{alpha(v)}>"
  end

  def to_grayscale(v)
    gray = (0.3*red(v) + 0.59*green(v) + 0.11*blue(v)).to_i
    rgba(gray, gray, gray, alpha(v))
  end

  private

  def clasp(value)
    value = value.to_i
    return 255 if value > 255
    return 0 if value < 0
    value
  end
end
