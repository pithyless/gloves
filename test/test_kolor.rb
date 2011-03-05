require 'minitest/autorun'
require_relative '../lib/kolor'

class TestKolor < MiniTest::Unit::TestCase
  def test_rgba
    c = Kolor.rgba(25,0,93,255)
    assert_equal Kolor.split(c), [25, 0, 93, 255]
    assert_equal Kolor.red(c), 25
    assert_equal Kolor.green(c), 0
    assert_equal Kolor.blue(c),  93
    assert_equal Kolor.alpha(c), 255
  end

  def test_rgba_clasp
    c = Kolor.rgba(301,-20,258,23)
    assert_equal [255, 0, 255, 23], Kolor.split(c)
  end

  def test_to_s
    c = Kolor.rgba(255,0,93,255)
    s = "<Kolor: 255, 93, 0, 255>"
    assert_equal s, Kolor.to_s(c)
  end

  def test_private_clasp
    refute_respond_to Kolor, :clasp
  end

  def test_make_invisible
    c = Kolor.invisible
    assert_equal [0, 0, 0, 0], Kolor.split(c)
    assert_equal true, Kolor.invisible?(c)
  end

  def test_colour_equal
    a = Kolor.rgba(24,52,92,255)
    b = Kolor.rgba(24,52,92,255)
    assert_equal a, b
  end

  def test_colour_not_equal
    a = Kolor.rgba(24,52,92,255)
    b = Kolor.rgba(24,51,92,255)
    assert a != b, 'Kolors should not be equal'
  end

  def test_gray?
    a = Kolor.rgba(24,52,92,255)
    b = Kolor.rgba(24,24,24,255)
    c = Kolor.rgba(0,0,0,0)
    assert (not Kolor.gray?(a)), 'Should not be gray'
    assert Kolor.gray?(b), 'Should be gray'
    assert (not Kolor.gray?(c)), 'Invisible is not gray'
  end

  def test_to_grayscale
    c = Kolor.rgba(45, 123, 170, 255)
    g = Kolor.to_grayscale(c)
    assert Kolor.gray?(g)
    assert_equal Kolor.gray(g), 104
    assert_equal Kolor.alpha(g), 255
  end

  def test_gray_colour
    g = Kolor.gray_alpha(45, 205)
    assert_equal [45, 205], Kolor.split_gray(g)
    assert_equal 45, Kolor.gray(g)
    assert_equal 205, Kolor.alpha(g)
  end

  def test_gray_clasp
    c = Kolor.gray_alpha(299, 301)
    assert_equal [255, 255], Kolor.split_gray(c)
    c = Kolor.gray_alpha(-23, 24)
    assert_equal [0, 24], Kolor.split_gray(c)
    c = Kolor.gray_alpha(42, 92)
    assert_equal [42, 92], Kolor.split_gray(c)
  end

  def test_gray_colour_equal
    a = Kolor.gray_alpha(24,255)
    b = Kolor.gray_alpha(24,255)
    assert_equal a, b
  end

  def test_gray_colour_not_equal
    a = Kolor.gray_alpha(24,255)
    b = Kolor.gray_alpha(21,255)
    assert a != b, 'Kolors should not be equal'
  end
end

