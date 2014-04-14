require_relative 'token'
require_relative 'token_type'

class AtToken < Token
  def initialize(index)
    @index = index
    @content = '@'
    @type = TokenType::At
  end
end