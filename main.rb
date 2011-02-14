require_relative 'lib/toolkit'

RUI::Application.init('hello') do |app|
  widget = Qt::Widget.new
  widget.gui = RUI::autogui do
    layout(:type => :vertical) do
      button(:name => :quit, :text => 'Quit')
    end
  end
  widget.quit.on(:clicked) { app.exit }
  widget.show
end
