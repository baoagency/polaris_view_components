require "test_helper"

class ActionListComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_action_list
    render_inline(Polaris::ActionListComponent.new) do |action_list|
      action_list.with_item { "Item" }
    end

    assert_selector ".Polaris-ActionList" do
      assert_selector "ul > li" do
        assert_selector "button.Polaris-ActionList__Item" do
          assert_selector ".Polaris-ActionList__Text", text: "Item"
        end
      end
    end
  end

  def test_sectioned_action_list
    render_inline(Polaris::ActionListComponent.new) do |action_list|
      action_list.with_section(title: "Section 1") do |section|
        section.with_item { "Item" }
      end
      action_list.with_section(title: "Section 2") do |section|
        section.with_item { "Item" }
      end
    end

    assert_selector ".Polaris-ActionList" do
      assert_text "Section 1"
      assert_text "Section 2"
    end
  end

  def test_item_with_url
    render_inline(Polaris::ActionListComponent.new) do |action_list|
      action_list.with_item(url: "#") { "Item" }
    end

    assert_selector "li > a.Polaris-ActionList__Item[href='#']" do
      assert_selector ".Polaris-ActionList__Text", text: "Item"
    end
  end

  def test_item_with_external_url
    render_inline(Polaris::ActionListComponent.new) do |action_list|
      action_list.with_item(url: "#", external: true) { "Item" }
    end

    assert_selector "a.Polaris-ActionList__Item[target=_blank]"
  end

  def test_item_with_icon
    render_inline(Polaris::ActionListComponent.new) do |action_list|
      action_list.with_item(icon: "ImportIcon") { "Item" }
    end

    assert_selector ".Polaris-ActionList__Item" do
      assert_selector ".Polaris-ActionList__Prefix > .Polaris-Icon"
    end
  end

  def test_item_with_prefix_and_suffix
    render_inline(Polaris::ActionListComponent.new) do |action_list|
      action_list.with_item do |item|
        item.with_prefix { "Prefix" }
        item.with_suffix { "Suffix" }
        "Item"
      end
    end

    assert_selector ".Polaris-ActionList__Prefix", text: "Prefix"
    assert_selector ".Polaris-ActionList__Suffix", text: "Suffix"
  end

  def test_item_with_help_text
    render_inline(Polaris::ActionListComponent.new) do |action_list|
      action_list.with_item(help_text: "HelpText") { "Item" }
    end

    assert_selector ".Polaris-ActionList__Text" do
      assert_text "Item"
      assert_text "HelpText"
    end
  end

  def test_active_item
    render_inline(Polaris::ActionListComponent.new) do |action_list|
      action_list.with_item(active: true) { "Item" }
    end

    assert_selector "li > .Polaris-ActionList__Item.Polaris-ActionList--active"
  end

  def test_destructive_item
    render_inline(Polaris::ActionListComponent.new) do |action_list|
      action_list.with_item(destructive: true) { "Item" }
    end

    assert_selector "li > .Polaris-ActionList__Item.Polaris-ActionList--destructive"
  end
end
