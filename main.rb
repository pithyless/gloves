
$toolkit = :qt
require 'rui'

RUI::Application.init('hello') do
  RUI::PushButton.new('Hello').show
end
