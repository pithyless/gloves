require_relative 'toolkit'
require_relative 'attache'

class LensView
  attr_reader :scene

  def initialize(attache)
    @attache = attache
    @attache.add_observer(self)
    @scene = Qt::GraphicsScene.new
    @attache.notify_of_changes
  end

  # callback for observer (attache)
  def update(time)
    @scene.clear
    @attache.lenses.each do |l|
      scene.addPixmap(l.image.to_pix)
    end
    @scene = scene
  end

  def current_lens
    @attache.current_lens
  end
end
