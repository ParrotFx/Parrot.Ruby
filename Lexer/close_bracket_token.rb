require_relative 'token'
require_relative 'token_type'

class CloseBracketToken < Token
  def initialize(index)
    @index = index
    @content = ']'
    @type = TokenType::CloseBracket
  end
end