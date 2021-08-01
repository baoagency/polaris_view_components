require "test_helper"

class ListComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_renders_bulleted_list
    render_inline(Polaris::ListComponent.new) do |list|
      list.item { "One" }
      list.item { "Two" }
      list.item { "Three" }
    end

    assert_selector "ul.Polaris-List"
    assert_selector ".Polaris-List__Item", count: 3
  end

  def test_renders_numbered_list
    render_inline(Polaris::ListComponent.new(type: :number)) do |list|
      list.item { "One" }
      list.item { "Two" }
      list.item { "Three" }
    end

    assert_selector "ol.Polaris-List--typeNumber"
    assert_selector ".Polaris-List__Item", count: 3
  end
end
