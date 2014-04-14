require_relative 'token'
require_relative 'token_type'

class GreaterThanToken < Token
  def initialize(index)
    @index = index
    @content = '>'
    @type = TokenType::GreaterThan
  end
end