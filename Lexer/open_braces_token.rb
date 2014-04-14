require_relative 'token'
require_relative 'token_type'

class OpenBracesToken < Token
  def initialize(index)
    @index = index
    @content = '{'
    @type = TokenType::OpenBrace
  end
end