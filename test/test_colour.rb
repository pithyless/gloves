require 'minitest/autorun'
require_relative '../lib/colour'

class TestColour < MiniTest::Unit::TestCase
  def test_rgba
    c = Colour.rgba(255,0,93,255)
    assert_equal c.red, 255
    assert_equal c.green, 0
    assert_equal c.blue, 93
    assert_equal c.alpha, 255
  end

  def test_rgba_clasp
    c = Colour.rgba(301,-20,258,23)
    assert_equal c.red, 255
    assert_equal c.green, 0
    assert_equal c.blue, 255
    assert_equal c.alpha, 23
  end

  def test_to_s
    c = Colour.rgba(255,0,93,255)
    s = "<Colour: 255, 93, 0, 255>"
    assert_equal c.to_s, s
  end

  def test_private_clasp
    c = Colour.rgba(255,0,93,255)
    refute_respond_to c, :clasp
  end
end
