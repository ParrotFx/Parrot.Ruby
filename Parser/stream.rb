class Stream
  def initialize(source)
    @list = source
    @index = -1
    @count = source.length
  end

  def peek
    temp = @index + 1
    while temp < @count do
      if @list[temp].type != TokenType::Whitespace
        return @list[temp]
      end

      temp += 1
    end

    return nil
  end

  def next_no_return
    @index += 1
    while @index < @count && @list[@index].type == TokenType::Whitespace
      @index += 1
    end
  end

  def next
    @index += 1

    while @index < @count
      if @list[@index].type != TokenType::Whitespace
        return @list[@index]
      end

      @index += 1
    end

    return nil
  end
end