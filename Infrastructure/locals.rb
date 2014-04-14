class Locals
  LocalsKey = '__locals'

  def initialize(host)
    if host == nil
      raise ArgumentNullException, "host"
    end

    @object_container = host

    if @object_container.contains_key(LocalsKey)
      @locals = @object_container[LocalsKey]
    else
      @locals = Hash.new
    end
  end

  def push(value)
    @locals.push(value)

    if @object_container[LocalsKey] != nil
      @object_container.delete(LocalsKey)
    end

    @object_container.push()

    return @locals.length - 1
  end

  def pop()
    if @locals.length > 0
      @locals.delete(@locals.length - 1)
    end
  end
end