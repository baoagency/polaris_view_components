require "test_helper"

class FormLayoutComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_form_layout
    render_inline(Polaris::FormLayoutComponent.new) do |form_layout|
      form_layout.with_item { "Item 1" }
      form_layout.with_item { "Item 2" }
    end

    assert_selector ".Polaris-FormLayout" do
      assert_selector ".Polaris-FormLayout__Item", count: 2
      assert_selector ".Polaris-FormLayout__Item:nth-child(1)", text: "Item 1"
      assert_selector ".Polaris-FormLayout__Item:nth-child(2)", text: "Item 2"
    end
  end

  def test_field_group
    render_inline(Polaris::FormLayoutComponent.new) do |form_layout|
      form_layout.with_group do |group|
        group.with_item { "Item 1" }
        group.with_item { "Item 2" }
      end
    end

    assert_selector ".Polaris-FormLayout > .Polaris-FormLayout--grouped[role=group]" do
      assert_selector ".Polaris-FormLayout__Items" do
        assert_selector ".Polaris-FormLayout__Item", count: 2
        assert_selector ".Polaris-FormLayout__Item:nth-child(1)", text: "Item 1"
        assert_selector ".Polaris-FormLayout__Item:nth-child(2)", text: "Item 2"
      end
    end
  end

  def test_condensed_group
    render_inline(Polaris::FormLayoutComponent.new) do |form_layout|
      form_layout.with_group(condensed: true) do |group|
        group.with_item { "Item 1" }
        group.with_item { "Item 2" }
      end
    end

    assert_selector ".Polaris-FormLayout > .Polaris-FormLayout--condensed[role=group]" do
      assert_selector ".Polaris-FormLayout__Items" do
        assert_selector ".Polaris-FormLayout__Item", count: 2
        assert_selector ".Polaris-FormLayout__Item:nth-child(1)", text: "Item 1"
        assert_selector ".Polaris-FormLayout__Item:nth-child(2)", text: "Item 2"
      end
    end
  end
end
