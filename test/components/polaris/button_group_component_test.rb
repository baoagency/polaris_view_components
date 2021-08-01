require "test_helper"

class ButtonGroupComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_group
    render_inline(Polaris::ButtonGroupComponent.new) do |group|
      group.button { "Cancel" }
      group.button { "Save" }
    end

    assert_selector ".Polaris-ButtonGroup" do
      assert_selector ".Polaris-ButtonGroup__Item", count: 2
      assert_selector ".Polaris-ButtonGroup__Item:nth-child(1)", text: "Cancel"
      assert_selector ".Polaris-ButtonGroup__Item:nth-child(2)", text: "Save"
    end
  end

  def test_segmented_group
    render_inline(Polaris::ButtonGroupComponent.new(segmented: true)) do |group|
      group.button { "Bold" }
      group.button { "Italic" }
      group.button { "Underline" }
    end

    assert_selector ".Polaris-ButtonGroup.Polaris-ButtonGroup--segmented[data-buttongroup-segmented='true']" do
      assert_selector ".Polaris-ButtonGroup__Item", count: 3
    end
  end

  def test_connected_tops_group
    render_inline(Polaris::ButtonGroupComponent.new(connected_top: true)) do |group|
      group.button { "Bold" }
      group.button { "Italic" }
    end

    assert_selector ".Polaris-ButtonGroup[data-buttongroup-connected-top='true']"
  end

  def test_full_width_group
    render_inline(Polaris::ButtonGroupComponent.new(full_width: true)) do |group|
      group.button { "Bold" }
      group.button { "Italic" }
    end

    assert_selector ".Polaris-ButtonGroup.Polaris-ButtonGroup--fullWidth[data-buttongroup-full-width='true']"
  end

  def test_items
    render_inline(Polaris::ButtonGroupComponent.new(full_width: true)) do |group|
      group.button { "Bold" }
      group.item { "Text" }
      group.button { "Italic" }
    end

    assert_selector ".Polaris-ButtonGroup .Polaris-ButtonGroup__Item:nth-child(2)", text: "Text"
  end

  def test_plain_items
    render_inline(Polaris::ButtonGroupComponent.new) do |group|
      group.button { "Enable two-step authentication" }
      group.button(plain: true) { "Learn more" }
    end

    assert_selector ".Polaris-ButtonGroup .Polaris-ButtonGroup__Item:nth-child(1)"
    assert_selector ".Polaris-ButtonGroup .Polaris-ButtonGroup__Item--plain:nth-child(2)"
  end
end
