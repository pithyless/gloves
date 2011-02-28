require 'observer'

class Attache
  include Observable

  attr_reader :lenses

  def initialize(filename)
    @doc_author = "Unknown"
    @doc_dpi    = 100
    @lenses = []
    add_lens(ScanLens.new(self, filename))
  end

  def add_lens(lens)
    @lenses << lens
    notify_of_changes
  end

  def notify_of_changes
    changed # notify observers
    notify_observers(Time.now)
  end

  def current_lens
    lenses[-1]
  end
end
