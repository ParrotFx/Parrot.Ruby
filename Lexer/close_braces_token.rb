require_relative 'token'
require_relative 'token_type'

class CloseBracesToken < Token
  def initialize(index)
    @index = index
    @content = '}'
    @type = TokenType::CloseBrace
  end
end