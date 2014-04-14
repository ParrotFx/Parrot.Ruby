require_relative 'token'
require_relative 'token_type'

class OpenBracketToken < Token
  def initialize(index)
    @index = index
    @content = '['
    @type = TokenType::OpenBracket
  end
end