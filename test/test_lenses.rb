require 'minitest/autorun'
require_relative '../lib/lenses'

class TestScanLens < MiniTest::Unit::TestCase
  def test_file_not_found
    assert_raises ImageFileNotFound do
      d = ScanLens.new('not_a_real_file.png')
    end
  end

  def test_to_color_lens
    d = ScanLens.new('test/test_sample.png')
    c = d.to_color_lens
    assert_instance_of(ColorLens, c)

    color_count, invisible_count = 0, 0
    c.each_pixel_chunky do |px|
      px = Colour.from_chunky(px)
      if px.invisible?
        invisible_count += 1
      else
        color_count += 1
      end
    end
    assert_equal 810,  color_count
    assert_equal 9862, invisible_count
  end
end

class TestColorLens < MiniTest::Unit::TestCase
  def test_not_initialized_with_image
    assert_raises RuntimeError do
      d = ColorLens.new(nil)
    end
  end

  def test_to_gray_lens
    d = ScanLens.new('test/test_sample.png')
    g = d.to_color_lens.to_gray_lens
    assert_instance_of(GrayLens, g)

    gray_count, invisible_count = 0, 0
    g.each_pixel_chunky do |px|
      px = GrayColour.from_chunky(px)
      if px.invisible?
        invisible_count += 1
      else
        gray_count += 1
      end
    end
    assert_equal 810,  gray_count
    assert_equal 9862, invisible_count
  end
end


class TestGrayLens < MiniTest::Unit::TestCase
  def test_not_initialized_with_image
    assert_raises RuntimeError do
      d = GrayLens.new(nil)
    end
  end
end


class TestOutlineLens < MiniTest::Unit::TestCase
  def test_not_initialized_with_image
    assert_raises RuntimeError do
      d = OutlineLens.new(nil)
    end
  end
end
