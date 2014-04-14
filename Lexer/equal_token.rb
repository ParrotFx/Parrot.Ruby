require_relative 'token'
require_relative 'token_type'

class EqualToken < Token
  def initialize(index)
    @index = index
    @content = "="
    @type = TokenType::Equal
  end
end