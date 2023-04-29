require "test_helper"

class StackComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_stack
    render_inline(Polaris::StackComponent.new) do |stack|
      stack.with_item { "Item 1" }
      stack.with_item { "Item 2" }
    end

    assert_selector ".Polaris-LegacyStack" do
      assert_selector ".Polaris-LegacyStack__Item", count: 2
      assert_selector ".Polaris-LegacyStack__Item:nth-child(1)", text: "Item 1"
      assert_selector ".Polaris-LegacyStack__Item:nth-child(2)", text: "Item 2"
    end
  end

  def test_spacing
    render_inline(Polaris::StackComponent.new(spacing: :loose))

    assert_selector ".Polaris-LegacyStack--spacingLoose"
  end

  def test_wrapping
    render_inline(Polaris::StackComponent.new(wrap: false))

    assert_selector ".Polaris-LegacyStack--noWrap"
  end

  def test_alignment
    render_inline(Polaris::StackComponent.new(alignment: :center))

    assert_selector ".Polaris-LegacyStack--alignmentCenter"
  end

  def test_distribution
    render_inline(Polaris::StackComponent.new(distribution: :fill))

    assert_selector ".Polaris-LegacyStack--distributionFill"
  end

  def test_item_fill
    render_inline(Polaris::StackComponent.new) do |stack|
      stack.with_item(fill: true) { "Item 1" }
    end

    assert_selector ".Polaris-LegacyStack > .Polaris-LegacyStack__Item--fill:nth-child(1)", text: "Item 1"
  end
end
