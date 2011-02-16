require 'test/unit'
require_relative '../lib/toolkit'

class TestQtColor < Test::Unit::TestCase
  def test_clasp_rgbF
    c = Qt::Color.clasp_rgbF(1.1, 0.6, -0.3, 0.4)
    vs = [c.redF, c.greenF, c.blueF, c.alphaF]

    assert_equal vs, [1.0, 0.6, 0.0, 0.4]
  end
end
