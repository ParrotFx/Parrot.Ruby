require_relative '../Parser/ErrorTypes/unexpected_token.rb'
Dir["../Lexer/*.rb"].each { |file| require file }
require_relative '../Parser/ErrorTypes/end_of_stream_exception.rb'
class Tokenizer
  def initialize(source)
    @source = StringScanner.new(source)
    @current_index = 0
  end

  def consume
    @current_index+=1
    character = @source.getch
    if character == nil
      raise EndOfStreamException
    end

    return character
  end

  def get_next_token
    peek = @source.peek(1)
    if is_identifier_head(peek)
      identifier = consume_identifier
      return IdentifierToken.new(
          @current_index,
          identifier
      )
    end

    if is_whitespace(peek)
      return WhitespaceToken.new(
          @current_index,
          consume_whitespace
      )
    end

    case peek
      when ','
        consume()
        return CommaToken.new(@current_index)
      when '('
        consume()
        return OpenParenthesisToken.new(@current_index)
      when ')'
        consume()
        return CloseParenthesisToken.new(@current_index)
      when '['
        consume()
        return OpenBracketToken.new(@current_index)
      when ']'
        consume()
        return CloseBracketToken.new(@current_index)
      when '='
        consume()
        return EqualToken.new(@current_index)
      when '{'
        consume()
        return OpenBracesToken.new(@current_index)
      when '}'
        consume()
        return CloseBracesToken.new(@current_index)
      when '>'
        consume()
        return GreaterThanToken.new(@current_index)
      when '+'
        consume()
        return PlusToken.new(@current_index)
      when '|'
        return StringLiteralPipeToken.new(
            @current_index,
            consume_until_newline_or_end_of_stream
        )
      when '"'
        return QuotedStringLiteralToken.new(
            @current_index,
            consume_quoted_string_literal('"')
        )
      when "'"
        return QuotedStringLiteralToken.new(
            @current_index,
            consume_quoted_string_literal("'")
        )
      when '@'
        consume()
        return AtToken.new(@current_index)
      when nil, ''
        return nil
      else
        puts "Unexpected token: " + peek
        raise "Unexpected token: " + peek
    end
  end

  def consume_until_newline_or_end_of_stream
    result = ''
    character = @source.peek(1)
    while !is_newline(character) do
      begin
        consume()
        result += character
        character = @source.peek(1)
      rescue EndOfStreamException => e
        break
      end
    end
    return result
  end

  def is_newline(character)
    return character == "\r" ||
      character == "\n" ||
      character == "\u0085" ||
      character == "\u2028" ||
      character == "\u2029"
  end

  def consume_identifier
    character = @source.peek(1)
    result = ''
    while is_id_tail(character) do
      consume()
      result += character
      character = @source.peek(1)
    end

    return result
  end

  def consume_whitespace
    character = @source.peek(1)
    result = ''
    while is_whitespace(character) do
      consume()
      result += character
      character = @source.peek(1)
    end
  end

  def consume_quoted_string_literal(quote)
    result = consume()
    character = @source.peek(1)
    while true do
      while character != quote do
        consume()
        result += character
        character = @source.peek(1)
      end
      result += consume()
      if @source.peek(1) != quote
        break
      end
      consume()
      character = @source.peek(1)
    end

    return result
  end

  def is_whitespace(character)
    return character == "\r" ||
           character == "\n" ||
        character == " " ||
        character == "\f" ||
        character == "\t" ||
        character == "\u000B"
  end

  def is_identifier_head(character)
    return /[[:alpha:]]/.match(character) != nil || character == '_' || character == '#' || character == '.'
  end

  def is_id_tail(character)
    return /[[:digit:]]/.match(character) != nil || is_identifier_head(character) || character == ':' || character == '-'
  end

  def tokenize
    tokens = Array.new
    while (token = get_next_token) && token != nil do
      tokens.push(token)
    end

    return tokens
  end

  def tokens
    return tokenize()
  end
end