require 'strscan'
require_relative 'stream'
require '../Nodes/statement.rb'
require '../Nodes/statement_tail.rb'
require '../Nodes/string_literal_pipe.rb'
class Parser
  def initialize()
    @errors = Array.new
  end

  def parse(stream, document)
    begin
      tokenizer = Tokenizer.new(stream)
      tokens = tokenizer.tokens

      token_stream = Stream.new(tokens)

      do_parse(token_stream) { |statement|
        statement.each do |s|
          parse_statement_errors(s)
          document.children.push(s)
        end
      }
    end

    document.errors = @errors

    return true
  end

  def parse_statement_errors(statement)
    if statement.errors.any?
      statement.errors.each do |error|
        @errors.push(error)
      end
    end
  end

  def do_parse(stream)
    while stream.peek != nil
      token = stream.peek
      case token.type
        when TokenType::StringLiteral, TokenType::StringLiteralPipe, TokenType::QuotedStringLiteral,
             TokenType::Identifier, TokenType::OpenBracket, TokenType::OpenParenthesis, TokenType::Equal,
             TokenType::At
          statement = parse_statement(stream)
          yield(statement)
        else
          errors.push(UnexpectedToken.new(token))
          stream.next()
      end
    end
  end

  def parse_statement(stream)
    previous_token = stream.peek()
    if previous_token == nil
      errors.push(EndOfStreamException.new())

      return StatementList.new()
    end

    token_type = previous_token.type
    identifier = nil
    case token_type
      when TokenType::Identifier
        identifier = stream.next()
      when TokenType::OpenBracket, TokenType::OpenParenthesis
      when TokenType::StringLiteral, TokenType::StringLiteralPipe, TokenType::QuotedStringLiteral
        identifier = stream.next()
      when TokenType::At
        stream.next()
        identifier = stream.next()
      when TokenType::Equal
        stream.next()
        identifier = stream.next()
      else
        errors.push(UnexpectedToken.new(previous_token))
        return StatementList.new()
    end

    tail = nil
    while stream.peek != nil
      token = stream.peek()
      if token == nil
        break
      end

      case token.type
        when TokenType::OpenParenthesis, TokenType::OpenBracket, TokenType::OpenBrace
          tail = parse_statement_tail(stream)
        when TokenType::GreaterThan
          stream.next()
          tail = parse_single_statement_tail(stream, tail)
        when TokenType::StringLiteralPipe
          if previous_token == StringLiteralPipeToken
            get_statement_from_token(identifier, tail)
            exit = true
            break
          end

          tail = parse_single_statement_tail(stream, tail)
        else
          get_statement_from_token(identifier, tail)
          exit = true
      end
      break if exit == true
    end

    statement = get_statement_from_token(identifier, tail, previous_token)

    list = Array.new
    list.push(statement)

    while stream.peek != nil
      if stream.peek.type == TokenType::Plus
        stream.next()
        siblings = parse_statement(stream)
        siblings.each do |sibling|
          list.push(sibling)
        end
      else
        break
      end
    end

    return list
  end

  def get_statement_from_token(identifier, tail, previous_token = nil)
    value = identifier != nil ? identifier.content : ''
    if identifier != nil
      case identifier.type
        when TokenType::StringLiteral, TokenType::QuotedStringLiteral
          return StringLiteral.new(value, tail)
        when TokenType::StringLiteralPipe
          return StringLiteralPipe.new(value[1, value.length - 1], tail)
      end
    end

    if previous_token != nil
      case previous_token.type
        when TokenType::At
          return EncodedOutput.new(value)
        when TokenType::Equal
          return RawOutput.new(value)
      end
    end

    return Statement.new(value, tail)
  end

  def parse_single_statement_tail(stream, tail)
    statement_list = parse_statement(stream)

    if tail == nil
      tail = StatementTail.new
    end

    tail.children = statement_list

    return tail
  end

  def parse_statement_tail(stream)
    children = nil
    parameters = nil
    attributes = nil

    while stream.peek != nil
      token = stream.peek
      if token == nil
        break
      end

      case token.type
        when TokenType::OpenParenthesis
          parameters = parse_parameters(stream)
        when TokenType::OpenBracket
          attributes = parse_attributes(stream)
        when TokenType::GreaterThan
          children = parse_child(stream)
        when TokenType::OpenBrace
          children = parse_children(stream)
          exit = true
        else
          exit = true
      end
      break if exit == true
    end

    return StatementTail.new(children, attributes, parameters)
  end

  def parse_child(stream)
    child = Array.new

    stream.next()

      token = stream.peek()
      if token != nil
        statements = parse_statement(stream)
        statements.each do |statement|
          child.push(statement)
        end
      end

      return child
  end

  def parse_children(stream)
    list = Array.new
    stream.next()

    while stream.peek != nil
      token = stream.peek()
      case token.type
        when TokenType::Plus
        when TokenType::CloseBrace
          stream.next()
          return list
        else
          statements = parse_statement(stream)
          statements.each do |statement|
            list.push(statement)
          end
      end
    end

    return list
  end

  def parse_parameters(stream)
    list = Array.new
    stream.next()

    while stream.peek != nil
      token = stream.peek()

      case token.type
        when TokenType::Identifier, TokenType::QuotedStringLiteral, TokenType::StringLiteralPipe
          list.push(parse_parameter(stream))
        when TokenType::Comma
          stream.next()
        when TokenType::CloseParenthesis
          stream.next()
          return list
        else
          @errors.push(UnexpectedToken.new(token))
          return list
      end
    end

    return list
  end

  def parse_parameter(stream)
    identifier = stream.next()
    case identifier.type
      when TokenType::StringLiteralPipe, TokenType::QuotedStringLiteral, TokenType::StringLiteral, TokenType::Identifier
      else
        @errors.push(UnexpectedToken.new(identifier))
        return nil
    end

    return Parameter.new(identifier.content)
  end

  def parse_attributes(stream)
    attributes = Array.new
    stream.next()

    while stream.peek() !=nil
      token = stream.peek()

      case token.type
        when TokenType::Identifier
          attributes.push(parse_attribute(stream))
        when TokenType::CloseBracket
          stream.next()
          exit = true
        else
      end

      break if exit == true
    end

    if attributes.length == 0
      @errors.push(AttributeListEmpty.new(token.index))
    end

    return attributes
  end

  def parse_attribute(stream)
    identifier = stream.next()
    equals_token = stream.peek()
    if equals_token.is_a? EqualToken
      stream.next()
      value_token = stream.peek()
      if value_token == nil
        @errors.push(UnexpectedToken.new(identifier))
        return Attribute.new(identifier.content, nil)
      end

      if value_token.type == TokenType::CloseBracket
        @errors.push(AttributeValueMissing.new())
      end

      value = parse_statement(stream)[0]

      if value != nil
        case value.name
          when "true", "false", "null"
            value = StringLiteral.new('"' + value.name + '"')
        end
      end

      return Attribute.new(identifier.content, value)
    end

    return Attribute.new(identifier.content, nil)
  end
end