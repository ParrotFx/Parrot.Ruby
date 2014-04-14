require_relative 'token'
require_relative 'token_type'

class OpenParenthesisToken < Token
  def initialize(index)
    @index = index
    @content = '('
    @type = TokenType::OpenParenthesis
  end
end