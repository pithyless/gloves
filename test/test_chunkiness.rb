require 'minitest/autorun'
require_relative '../lib/chunkiness'

class TestChunkyColour < MiniTest::Unit::TestCase
  def test_colour_from_to_chunky
    r = ChunkyPNG::Color.rgba(23, 42, 193, 255)
    c = Colour.from_chunky(r)
    assert_instance_of(Colour, c)
    assert_equal c.red, 23
    assert_equal c.green, 42
    assert_equal c.blue, 193
    assert_equal c.alpha, 255
    r2 = c.to_chunky
    assert_equal r, r2
  end

  def test_gray_from_to_chunky
    r = ChunkyPNG::Color.rgba(23, 23, 23, 255)
    c = GrayColour.from_chunky(r)
    assert_instance_of(GrayColour, c)
    assert_equal c.gray, 23
    assert_equal c.alpha, 255
    r2 = c.to_chunky
    assert_equal r, r2
  end

  def test_bad_gray_from_to_chunky
    r = ChunkyPNG::Color.rgba(23, 233, 224, 255)
    assert_raises ColourMismatch do
      c = GrayColour.from_chunky(r)
    end
  end
end

