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
end
