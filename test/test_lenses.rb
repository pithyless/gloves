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
    c.image.to_chunky_image.map_pixels do |px|
      if Kolor.invisible?(px)
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
    g.image.to_chunky_image.map_pixels do |px|
      if Kolor.invisible?(px)
        invisible_count += 1
      elsif Kolor.gray?(px)
        gray_count += 1
      else
        raise 'Should always be gray or invisible'
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

  def test_to_outline_lens
    d = ScanLens.new('test/test_sample.png')
    lens = d.to_color_lens.to_gray_lens.to_outline_lens
    assert_instance_of(OutlineLens, lens)

    cnt_bg, cnt_outer_line, cnt_inner_line = 0, 0, 0
    cnt_inner_region, cnt_inner_stroke = 0, 0
    cnt_invisible = 0

    lens.image.to_chunky_image.map_pixels do |px|
      if Kolor.invisible?(px)
        cnt_invisible += 1
      elsif px == OutlineLens::C_BACKGROUND
        cnt_bg += 1
      elsif px == OutlineLens::C_OUTER_LINE_BORDER
        cnt_outer_line += 1
      elsif px == OutlineLens::C_INNER_LINE_BORDER
        cnt_inner_line += 1
      elsif px == OutlineLens::C_INNER_REGION
        cnt_inner_region += 1
      elsif px == OutlineLens::C_INNER_STROKE
        cnt_inner_stroke += 1
      else
        raise 'Could not match color!'
      end
    end
    assert_equal 0, cnt_invisible
    assert_equal 9548, cnt_bg
    assert_equal 737, cnt_outer_line
    assert_equal 65, cnt_inner_line
    assert_equal 314, cnt_inner_region
    assert_equal 8, cnt_inner_stroke
  end
end


class TestOutlineLens < MiniTest::Unit::TestCase
  def test_not_initialized_with_image
    assert_raises RuntimeError do
      d = OutlineLens.new(nil)
    end
  end
end
