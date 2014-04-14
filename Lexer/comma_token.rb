require_relative 'token'
require_relative 'token_type'

class CommaToken < Token
  def initialize(index)
    @index = index
    @content = ','
    @type = TokenType::Comma
  end
end