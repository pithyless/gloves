require_relative 'lib/toolkit'

RUI::Application.init('hello') do |app|
  img = Qt::Image.new('samples/01-a-100.png')

  widget = Qt::Widget.new
  widget.gui = RUI::autogui do
    layout :type => :horizontal do
      layout :type => :vertical do
        scroll_area :name => :scrollable do
          label :name => :pic_label, :image => img
        end
        label :name => :footer_label, :text => 'Footer'
      end
      layout :type => :vertical do
        button :name => :hello, :text => 'Hello'
        button :name => :quit, :text => 'Quit'
      end
    end
  end
  widget.quit.on(:clicked) { app.exit }
  widget.show
end
