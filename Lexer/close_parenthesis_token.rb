require_relative 'token'
require_relative 'token_type'

class CloseParenthesisToken < Token
  def initialize(index)
    @index = index
    @content = ')'
    @type = TokenType::CloseParenthesis
  end
end