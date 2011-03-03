require 'observer'

class Attache
  include Observable

  attr_reader :lenses

  def initialize(filename)
    @doc_author = "Unknown"
    @doc_dpi    = 100
    @lenses = []
    add_lens(ScanLens.new(filename))
  end

  def notify_of_changes
    changed # notify observers
    notify_observers(Time.now)
  end

  def add_lens(lens)
    @lenses << lens
    notify_of_changes
  end

  def lenses_count
    @lenses.size
  end

  def current_lens
    lenses[-1]
  end
end
