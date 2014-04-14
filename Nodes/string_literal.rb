require_relative 'string_literal_part_type'
require_relative 'statement'
require_relative '../Infrastructure/value_type.rb'
require_relative 'string_literal_part'

class StringLiteral < Statement
  def values
    return @values
  end
  def value_type
    return @value_type
  end

  def initialize(value, tail = nil)
    super('string', tail)

    if is_wrapped_in_quotes(value)
      @value_type = ValueType::StringLiteral
      #set value = inner value
      value = value[1..value.length-2]
    elsif value == "this"
      @value_type = ValueType::Local
    elsif value == "null" || value == "true" || value == "false"
      @value_type = ValueType::Keyword
    else
      @value_type = ValueType::Property
    end

    if @value_type == ValueType::StringLiteral
      @values = parse(value)
    end
  end

  def is_wrapped_in_quotes(value)
    return (/^'/.match(value) && /'$/.match(value)) || (/^\"/.match(value) && /"$/.match(value))
  end

  def parse(source)
    parts = Array.new
    temp_counter = 0
    c = Array.new
    for i in 0..source.length
      if source[i] == '@' || source[i] == '='
        comparer = source[i]
        comparer_type = comparer == '@' ? StringLiteralPartType::Encoded : SringLiteralPartType::Raw
        i+=1
        if source[Math.min(source.length - 1, i)] == comparer
          c[temp_counter] = comparer
          temp_counter+=1
        elsif is_identifier_head(source[i])
          if temp_counter > 0
            parts.push(StringLiteralPart.new(StringLiteralPartType::Literal, c[0..temp_counter].join(''), i - temp_counter))
          end

          temp_counter= 0

          word = ''
          while i < source.length
            if !is_id_tail(source[i])
              break
            end

            word += source[i]
            i+=1
            temp_counter+=1
          end

          if word[word.length-1] == '.'
            word.length -=1
            parts.push(StringLiteralPart.new(comparer_type, word.join(''), i - temp_counter))
            temp_counter = 0
            c[temp_counter] = '.'
            temp_counter+=1
          else
            parts.push(StringLiteralPart.new(comparer_type, word.join(''), i - temp_counter))
            temp_counter = 0
          end

          if i < source.length
            c[temp_counter] = source[i]
            temp_counter +=1
          end
        else
          c[temp_counter] = comparer
          temp_counter += 1
          i -= 1
        end
      else
        c[temp_counter] = source[i]
        temp_counter += 1
      end
    end

    if temp_counter > 0
      parts.push(StringLiteralPart.new(StringLiteralPartType::Literal, c[0..temp_counter].join(''), source.length - temp_counter))
    end

    return parts
  end

  def is_identifier_head(character)
    return character == /[[:alpha:]]/ ||
        character == '_' ||
        character == '#' ||
        character == '.'
  end

  def is_id_tail(character)
    return character == /[[:digit:]]/ ||
        character == is_identifier_head(character) ||
        character == ':' ||
        character == '-'
  end

end