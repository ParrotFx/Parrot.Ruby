require_relative 'token'
require_relative 'token_type'
class WhitespaceToken < Token
  def initialize(index, content)
    @index = index
    @content = content
    @type = TokenType::Whitespace
  end
end