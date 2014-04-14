require_relative 'abstract_node'
require_relative 'identifier_type'
require_relative 'identifier'
require_relative 'attribute'
require_relative 'statement'
require_relative '../Parser/ErrorTypes/multiple_id_declarations.rb'

class Statement < AbstractNode
  def parameters
    return @parameters
  end

  def name
    return @name
  end
  def name= name
    @name = name
  end

  def attributes
    return @attributes
  end

  def children
    return @children
  end

  def index
    return @index
  end
  def index= index
    @index = index
  end

  def length
    return @length
  end
  def length= length
    @length = length
  end

  def identifier_parts
    return @identifier_parts
  end

  def errors
    return @errors
  end
  def errors= errors
    @errors = errors
  end

  def initialize(name = nil, tail = nil)
    @attributes = Array.new
    @children = Array.new
    @parameters = Array.new
    @identifier_parts = Array.new
    @errors = Array.new

    if name != nil
      if name.index(/[.#:]/) != nil
        #foreach part in get_identifier_parts
        get_identifier_parts(name) { |part|
          case part.type
            when IdentifierType::Id
              if part.name.length == 0
                @errors.push(MissingIdDeclaration.new())
              elsif @attributes.any? { |a| a.key == 'id' }
                @errors.push(MultipleIdDeclarations.new(part.name))
              else
                add_attribute(Attribute.new("id", StringLiteral.new('"' + part.name + '"')))
              end
            when IdentifierType::Class
              if part.name.length == 0
                @errors.push(MissingClassDeclaration.new())
              else
                add_attribute(Attribute.new("class", StringLiteral.new('"' + part.name + '"')))
              end
            when IdentifierType::Type
              add_attribute(Attribute.new("type", StringLiteral.new('"' + part.name + '"')))
            when IdentifierType::Literal
              @name = part.name
          end

          @identifier_parts.push(part)
        }
      else
        @name = name
      end
    end

    if tail != nil
      parse_statement_tail(tail)
    end
  end

  def identifier_type_from_character(source)
    case source
      when ':'
        return IdentifierType::Type
      when '#'
        return IdentifierType::Id
      when '.'
        return IdentifierType::Class
      else
        return IdentifierType::None
    end
  end

  def parse_statement_tail(tail = nil)
    if tail != nil
      if tail.parameters != nil
        @parameters = tail.parameters
      end

      if tail.attributes != nil
        @attributes.each do |attribute|
          tail.attributes.add(attribute)
        end
        @attributes = tail.attributes
      end

      if tail.children != nil
        @children = tail.children
      end
    end
  end

  def add_attributes(attributes)
    if attributes != nil
      attributes.each do |attribute|
        @attributes.push(attribute)
      end
    end
  end

  def add_attribute(node)
    @attributes.push(node)
  end

  def get_identifier_parts(source)
    index = 0
    part_type = IdentifierType::Literal
    next_type = IdentifierType::None

    for i in 0..source.length
      next_type = identifier_type_from_character(source[i])

      if next_type != IdentifierType::None
        yield(Identifier.new(
            source[index, i - index],
            part_type,
            index,
            i - index
        ))

        index = i + 1
        part_type = next_type
      end
    end

    yield(Identifier.new(
        source[index, source.length - index],
        part_type,
        index,
        index
    ))
  end
end