require 'Qt4'

app = Qt::Application.new(ARGV)

hello = Qt::PushButton.new('Hello World!')
hello.resize(100, 30)
hello.show()

app.exec()
