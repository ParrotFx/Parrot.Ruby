require_relative './parser_error.rb'

class UnexpectedToken < ParserError
  def type
    return @type
  end

  def type=type
    @type = type
  end

  def token
    return @token
  end

  def initialize(token)
    @index = token.index
    @token = token.content
    @type = token.type
  end
end