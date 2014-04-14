require_relative 'token'
require_relative 'token_type'

class PlusToken < Token
  def initialize(index)
    @index = index
    @content = '+'
    @type = TokenType::Plus
  end
end