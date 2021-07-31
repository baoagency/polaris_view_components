require "test_helper"

class ButtonGroupComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_group
    render_inline(Polaris::ButtonGroupComponent.new) do |group|
      group.item { "Cancel" }
      group.item { "Save" }
    end

    assert_selector ".Polaris-ButtonGroup" do
      assert_selector ".Polaris-ButtonGroup__Item", count: 2
      assert_selector ".Polaris-ButtonGroup__Item:nth-child(1)", text: "Cancel"
      assert_selector ".Polaris-ButtonGroup__Item:nth-child(2)", text: "Save"
    end
  end

  def test_segmented_group
    render_inline(Polaris::ButtonGroupComponent.new(segmented: true)) do |group|
      group.item { "Bold" }
      group.item { "Italic" }
      group.item { "Underline" }
    end

    assert_selector ".Polaris-ButtonGroup.Polaris-ButtonGroup--segmented[data-buttongroup-segmented='true']" do
      assert_selector ".Polaris-ButtonGroup__Item", count: 3
    end
  end

  def test_connected_tops_group
    render_inline(Polaris::ButtonGroupComponent.new(connected_top: true)) do |group|
      group.item { "Bold" }
      group.item { "Italic" }
    end

    assert_selector ".Polaris-ButtonGroup[data-buttongroup-connected-top='true']"
  end

  def test_full_width_group
    render_inline(Polaris::ButtonGroupComponent.new(full_width: true)) do |group|
      group.item { "Bold" }
      group.item { "Italic" }
    end

    assert_selector ".Polaris-ButtonGroup.Polaris-ButtonGroup--fullWidth[data-buttongroup-full-width='true']"
  end
end
