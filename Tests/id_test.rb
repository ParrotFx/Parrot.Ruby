require 'test/unit'
require '../Lexer/tokenizer.rb'
require '../Parser/parser.rb'
require '../Nodes/document.rb'
require '../Parser/ErrorTypes/missing_id_declaration.rb'

class IdTest < Test::Unit::TestCase

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

  def test_element_with_id_produces_block_element_with_id_attribute
    document = parse('div#sample-id')
    assert_equal 'id', document.children[0].attributes[0].key
    assert_equal 'sample-id', document.children[0].attributes[0].value.values[0].data
  end

  def test_element_with_two_or_more_ids
    document = parse('div#first-id#second-id#third-id')
    assert_equal 'second-id', document.errors[0].id
    assert_equal 'third-id', document.errors[1].id
  end

  def test_element_with_extra_id
    document = parse('div#first-id#second-id')
    assert_equal 'second-id', document.errors[0].id
  end

  def test_element_with_empty_id_declaration
    document = parse('div#')
    assert_equal true, (document.errors[0].is_a? MissingIdDeclaration)
  end
end