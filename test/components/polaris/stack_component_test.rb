require "test_helper"

class StackComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_stack
    render_inline(Polaris::StackComponent.new) do |stack|
      stack.item { "Item 1" }
      stack.item { "Item 2" }
    end

    assert_selector ".Polaris-Stack" do
      assert_selector ".Polaris-Stack__Item", count: 2
      assert_selector ".Polaris-Stack__Item:nth-child(1)", text: "Item 1"
      assert_selector ".Polaris-Stack__Item:nth-child(2)", text: "Item 2"
    end
  end

  def test_spacing
    render_inline(Polaris::StackComponent.new(spacing: :loose))

    assert_selector ".Polaris-Stack--spacingLoose"
  end

  def test_wrapping
    render_inline(Polaris::StackComponent.new(wrap: false))

    assert_selector ".Polaris-Stack--noWrap"
  end

  def test_alignment
    render_inline(Polaris::StackComponent.new(alignment: :center))

    assert_selector ".Polaris-Stack--alignmentCenter"
  end

  def test_distribution
    render_inline(Polaris::StackComponent.new(distribution: :fill))

    assert_selector ".Polaris-Stack--distributionFill"
  end

  def test_item_fill
    render_inline(Polaris::StackComponent.new) do |stack|
      stack.item(fill: true) { "Item 1" }
    end

    assert_selector ".Polaris-Stack > .Polaris-Stack__Item--fill:nth-child(1)", text: "Item 1"
  end
end
