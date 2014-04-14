require 'test/unit'
require '../Lexer/tokenizer.rb'
require '../Parser/parser.rb'
require '../Nodes/document.rb'
require '../Parser/ErrorTypes/missing_id_declaration.rb'
require '../Parser/ErrorTypes/missing_class_declaration.rb'
require '../Parser/ErrorTypes/attribute_value_missing.rb'

class AttributeTest < Test::Unit::TestCase

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

  def test_element_with_single_attribute_produces_block_element_with_attribute
    document = parse('div[attr1="value1"]')
    assert_equal 1, document.children[0].attributes.length
  end

  def test_element_with_multiple_attributes_produces_block_element_with_multiple_attributes
    document = parse('div[attr1="value1" attr2="value2"]')
    assert_equal 2, document.children[0].attributes.length
  end

  def test_element_with_attribute_with_no_value_produces_attribute_with_value_set_to_null
    document = parse('div[attr]')
    assert_nil document.children[0].attributes[0].value
    assert_equal 'attr', document.children[0].attributes[0].key
  end

  def test_element_with_missing_attribute_value_but_with_equals_adds_error_to_document_errors
    document = parse('div[attr1=]')
    assert_true (document.errors[0].is_a? AttributeValueMissing)
  end
end