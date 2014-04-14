require 'test/unit'
require '../Lexer/tokenizer.rb'
require '../Parser/parser.rb'
require '../Nodes/document.rb'
require '../Parser/ErrorTypes/missing_id_declaration.rb'
require '../Parser/ErrorTypes/missing_class_declaration.rb'

class ClassTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def parse(element)
    parser = Parser.new
    document = Document.new
    parser.parse(element, document)
    return document
  end

  def test_element_with_class_produces_block_element_with_class_attribute
    document = parse('div.sample-class')
    assert_equal 'class', document.children[0].attributes[0].key
    assert_equal 'sample-class', document.children[0].attributes[0].value.values[0].data
  end

  def test_element_with_multiple_class_produces_block_element_with_class_element_separated_by_spaces
    document = parse('div.class1.class2.class3')
    assert_equal 'class', document.children[0].attributes[0].key
    assert_equal 'class1', document.children[0].attributes[0].value.values[0].data
    assert_equal 'class2', document.children[0].attributes[1].value.values[0].data
    assert_equal 'class3', document.children[0].attributes[2].value.values[0].data
  end

  def test_element_with_empty_class_declaration
    document = parse('div.')
    assert_equal true, (document.errors[0].is_a? MissingClassDeclaration)
  end
end