require_relative 'string_literal'

class StringLiteralPipe < StringLiteral
  def initialize(value, tail = nil)
    super('"' + value + '"', tail)
  end
end