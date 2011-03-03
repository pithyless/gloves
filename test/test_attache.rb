require 'minitest/autorun'
require_relative '../lib/attache'

class TestAttache < MiniTest::Unit::TestCase
  def test_new_attache
    a = Attache.new('test/test_sample.png')
    assert 1, a.lenses_count
    assert_instance_of ScanLens, a.current_lens
    # todo: assert notify_observers was called
  end
end

