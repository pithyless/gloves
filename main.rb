require_relative 'lib/toolkit'

RUI::Application.init('hello') do
  RUI::PushButton.new('Hello').show
end
