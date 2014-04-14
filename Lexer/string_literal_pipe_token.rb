require_relative 'token'
require_relative 'token_type'

class StringLiteralPipeToken < Token
  def initialize(index, content)
    @index = index
    @content = content
    @type = TokenType::StringLiteralPipe
  end
end