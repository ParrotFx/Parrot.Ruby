class ValueTypeProvider
  def get_value(value)
    if value == nil
      return ValueTypeResult.new(
          ValueType::StringLiteral,
          nil
      )
    end

    result = ValueTypeResult.new()

    if is_wrapped_in_quotes(value)
      result.type = ValueType::StringLiteral
      result.value = value[1, value.length - 2]
    else
      if keyword_handlers.value[value] != nil
        result = get_value_handler(value)
      else
        result.type = ValueType::Property
        result.Value = value
      end
    end

    return result
  end

  def get_value_handler(keyword)
    case keyword
      when 'this'
        return ValueTypeResult.new(ValueType::Local, 'this')
      when 'false'
        return ValueTypeResult.new(ValueType::Keyword, false)
      when 'true'
        return ValueTypeResult.new(ValueType::Keyword, true)
      when 'nil'
        return ValueTypeResult.new(ValueType::Keyword, nil)
    end
  end

  def is_wrapped_in_quotes(value)
    return (/^'/.match(value) && /$'/.match(value)) || (/^"/.match(value) && /$"/.match(value))
  end
end