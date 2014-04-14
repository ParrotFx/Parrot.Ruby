require_relative 'token'
require_relative 'token_type'

class IdentifierToken < Token
  def initialize(index, content)
    @index = index
    @content = content
    @type = TokenType::Identifier
  end
end