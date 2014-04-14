require 'test/unit'
require '../Lexer/tokenizer.rb'
require '../Parser/parser.rb'
require '../Nodes/document.rb'

class TagTest < Test::Unit::TestCase

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

  def test_element_produces_block_element
    document = parse('div')
    assert_not_nil document
    assert_equal 'div', document.children[0].name
  end

  def test_element_followed_by_whitespace_and_another_element_produces_two_block_elements
    document = parse("div1 div2")
    assert_equal 2, document.children.length
  end

  def test_element_with_multiple_children_elements
    document = parse('div { div1 div2 }')
    assert_equal 2, document.children[0].children.length
  end

  def test_statement_with_one_sibling
    document = parse('div1 + div2')
    assert_equal 2, document.children.length
    assert_equal 'div1', document.children[0].name
    assert_equal 'div2', document.children[1].name
  end

  def test_statement_with_child_followed_by_statement
    document = parse('parent > child statement')
    assert_equal 2, document.children.length
    assert_equal 'parent', document.children[0].name
    assert_equal 'statement', document.children[1].name
    assert_equal 'child', document.children[0].children[0].name
  end

  def test_statement_with_child_followed_by_statement_with_child
    document = parse('parent > child statement > child2')
    assert_equal 2, document.children.length
    assert_equal 'parent', document.children[0].name
    assert_equal 'statement', document.children[1].name
    assert_equal 'child', document.children[0].children[0].name
    assert_equal 'child2', document.children[1].children[0].name
  end

  def test_statement_with_literal_child_followed_by_statement_with_child
    document = parse("parent |child\r\nstatement > child2")
    assert_equal 2, document.children.length
    assert_equal 'parent', document.children[0].name
    assert_equal 'statement', document.children[1].name
    assert_equal 'string', document.children[0].children[0].name
  end

  def test_statement_with_two_siblings
    document = parse('div1 + div2 + div3')
    assert_equal 3, document.children.length
    assert_equal 'div1', document.children[0].name
    assert_equal 'div2', document.children[1].name
    assert_equal 'div3', document.children[2].name
  end

  def test_statement_with_children_identified_as_siblings
    document = parse('div1 > child1 + child2')
    assert_equal 1, document.children.length
    assert_equal 2, document.children[0].children.length
    assert_equal 'child1', document.children[0].children[0].name
    assert_equal 'child2', document.children[0].children[1].name
  end

  def test_statement_with_children_identified_as_siblings2
    document = parse('div1 > div2 > child1 + child2')
    assert_equal 1, document.children.length
    assert_equal 2, document.children[0].children[0].children.length
    assert_equal 'child1', document.children[0].children[0].children[0].name
    assert_equal 'child2', document.children[0].children[0].children[1].name
  end

  def test_statement_with_one_child
    document = parse('div > span')
    assert_equal 'div', document.children[0].name
    assert_equal 'span', document.children[0].children[0].name
  end

  def test_statement_with_nested_children
    document = parse('div > span > a')
    assert_equal 'div', document.children[0].name
    assert_equal 'span', document.children[0].children[0].name
    assert_equal 'a', document.children[0].children[0].children[0].name
  end
end