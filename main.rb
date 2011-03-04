require_relative 'lib/toolkit'

require_relative 'lib/lens_view'
require_relative 'lib/lenses'

RUI::Application.init('hello') do |app|
  widget = Qt::Widget.new
  widget.gui = RUI::autogui do
    layout :type => :horizontal do
      layout :type => :vertical do
        graphics_view :name => :graph_view
        label :name => :footer_label, :text => 'Footer'
      end
      layout :type => :vertical do
        button :name => :crop_btn, :text => 'Crop'
        button :name => :colorize, :text => 'Colorize'
        button :name => :grayify, :text => 'Grayify'
        button :name => :outlinify, :text => 'Outline'
        button :name => :quit, :text => 'Quit'
      end
    end
  end

  # attache = Attache.new('samples/01-a-100-2.png')
  # attache = Attache.new('test/test_sample.png')
  attache = Attache.new('test/test_sample2.png')

  lv = LensView.new(attache)
  widget.graph_view.setScene(lv.scene)
  # widget.graph_view.scale(3.0,3.0)

  widget.crop_btn.on(:clicked) do
    # todo: selection
    # lv.current_lens.new_crop(Qt::Rect.new(20,20, 120, 120))
    p = lv.current_lens.copy(20, 20, 120, 120)
    lv.add_lens(p)
  end

  # widget.graph_scene.addWidget(
  #   MonocleSelectorWidget.new(nil, widget.graph_view))

  widget.colorize.on(:clicked) do
    c = attache.current_lens.to_color_lens
    attache.add_lens(c)

    widget.colorize.enabled = false    # todo - should be automagic
  end
  widget.grayify.on(:clicked) do
    c = attache.current_lens.to_gray_lens
    attache.add_lens(c)

    widget.grayify.enabled = false    # todo - should be automagic
  end
  widget.outlinify.on(:clicked) do
    c = attache.current_lens.to_outline_lens
    attache.add_lens(c)

    widget.grayify.enabled = false    # todo - should be automagic
  end
  widget.quit.on(:clicked) { app.exit }
  widget.show
end
