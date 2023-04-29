require "test_helper"

class ButtonGroupComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_group
    render_inline(Polaris::ButtonGroupComponent.new) do |group|
      group.with_button { "Cancel" }
      group.with_button(primary: true) { "Save" }
    end

    assert_selector ".Polaris-ButtonGroup" do
      assert_selector ".Polaris-ButtonGroup__Item", count: 2
      assert_selector ".Polaris-ButtonGroup__Item:nth-child(1)" do
        assert_selector ".Polaris-Button", text: "Cancel"
      end
      assert_selector ".Polaris-ButtonGroup__Item:nth-child(2)" do
        assert_selector ".Polaris-Button.Polaris-Button--primary", text: "Save"
      end
    end
  end

  def test_segmented_group
    render_inline(Polaris::ButtonGroupComponent.new(segmented: true)) do |group|
      group.with_button { "Bold" }
      group.with_button { "Italic" }
      group.with_button { "Underline" }
    end

    assert_selector ".Polaris-ButtonGroup.Polaris-ButtonGroup--segmented[data-buttongroup-segmented='true']" do
      assert_selector ".Polaris-ButtonGroup__Item", count: 3
    end
  end

  def test_connected_tops_group
    render_inline(Polaris::ButtonGroupComponent.new(connected_top: true)) do |group|
      group.with_button { "Bold" }
      group.with_button { "Italic" }
    end

    assert_selector ".Polaris-ButtonGroup[data-buttongroup-connected-top='true']"
  end

  def test_full_width_group
    render_inline(Polaris::ButtonGroupComponent.new(full_width: true)) do |group|
      group.with_button { "Bold" }
      group.with_button { "Italic" }
    end

    assert_selector ".Polaris-ButtonGroup.Polaris-ButtonGroup--fullWidth[data-buttongroup-full-width='true']"
  end

  def test_group_with_text_item
    render_inline(Polaris::ButtonGroupComponent.new) do |group|
      group.with_button { "Button1" }
      group.with_item { "Item1" }
      group.with_button { "Button2" }
    end

    assert_selector ".Polaris-ButtonGroup" do
      assert_selector ".Polaris-ButtonGroup__Item", count: 3
      assert_selector ".Polaris-ButtonGroup__Item:nth-child(1)", text: "Button1"
      assert_selector ".Polaris-ButtonGroup__Item:nth-child(2)", text: "Item1"
      assert_selector ".Polaris-ButtonGroup__Item:nth-child(3)", text: "Button2"
    end
  end

  def test_plain_items
    render_inline(Polaris::ButtonGroupComponent.new) do |group|
      group.with_button { "Enable two-step authentication" }
      group.with_button(plain: true) { "Learn more" }
    end

    assert_selector ".Polaris-ButtonGroup .Polaris-ButtonGroup__Item:nth-child(1)"
    assert_selector ".Polaris-ButtonGroup .Polaris-ButtonGroup__Item--plain:nth-child(2)"
  end

  def test_nowrap
    render_inline(Polaris::ButtonGroupComponent.new(nowrap: true)) do |group|
      group.with_button { "Bold" }
      group.with_button { "Italic" }
    end

    assert_selector ".Polaris-ButtonGroup.Polaris-ButtonGroup--noWrap"
  end
end
