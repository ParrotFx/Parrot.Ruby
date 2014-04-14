require_relative 'token'
require_relative 'token_type'

class QuotedStringLiteralToken < Token
  def initialize(index, content)
    @index = index
    @content = content
    @type = TokenType::QuotedStringLiteral
  end
end