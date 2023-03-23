require "test_helper"

class ActionListComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_action_list
    render_inline(Polaris::ActionListComponent.new) do |action_list|
      action_list.item { "Item" }
    end

    assert_selector ".Polaris-ActionList > .Polaris-ActionList__Section--withoutTitle" do
      assert_selector "ul.Polaris-ActionList__Actions > li" do
        assert_selector "button.Polaris-ActionList__Item > .Polaris-ActionList__Content" do
          assert_selector ".Polaris-ActionList__Text", text: "Item"
        end
      end
    end
  end

  def test_sectioned_action_list
    render_inline(Polaris::ActionListComponent.new) do |action_list|
      action_list.section(title: "Section 1") do |section|
        section.item { "Item" }
      end
      action_list.section(title: "Section 2") do |section|
        section.item { "Item" }
      end
    end

    assert_selector ".Polaris-ActionList" do
      assert_selector "div:nth-child(1)" do
        assert_selector "p.Polaris-ActionList__Title.Polaris-ActionList--firstSectionWithTitle" do
          assert_text "Section 1"
        end
      end
      assert_selector "div:nth-child(2) > p.Polaris-ActionList__Title" do
        assert_text "Section 2"
      end
    end
  end

  def test_item_with_url
    render_inline(Polaris::ActionListComponent.new) do |action_list|
      action_list.item(url: "#") { "Item" }
    end

    assert_selector "li > a.Polaris-ActionList__Item[href='#']" do
      assert_selector ".Polaris-ActionList__Content > .Polaris-ActionList__Text", text: "Item"
    end
  end

  def test_item_with_external_url
    render_inline(Polaris::ActionListComponent.new) do |action_list|
      action_list.item(url: "#", external: true) { "Item" }
    end

    assert_selector "a.Polaris-ActionList__Item[target=_blank]"
  end

  def test_item_with_icon
    render_inline(Polaris::ActionListComponent.new) do |action_list|
      action_list.item(icon: "ImportMinor") { "Item" }
    end

    assert_selector ".Polaris-ActionList__Item > .Polaris-ActionList__Content" do
      assert_selector ".Polaris-ActionList__Prefix > .Polaris-Icon"
    end
  end

  def test_item_with_prefix_and_suffix
    render_inline(Polaris::ActionListComponent.new) do |action_list|
      action_list.item do |item|
        item.prefix { "Prefix" }
        item.suffix { "Suffix" }
        "Item"
      end
    end

    assert_selector ".Polaris-ActionList__Content" do
      assert_selector ".Polaris-ActionList__Prefix", text: "Prefix"
      assert_selector ".Polaris-ActionList__Suffix", text: "Suffix"
    end
  end

  def test_item_with_help_text
    render_inline(Polaris::ActionListComponent.new) do |action_list|
      action_list.item(help_text: "HelpText") { "Item" }
    end

    assert_selector ".Polaris-ActionList__Content > .Polaris-ActionList__Text" do
      assert_selector ".Polaris-ActionList__ContentBlock" do
        assert_selector ".Polaris-ActionList__ContentBlockInner", text: "Item"
        assert_selector ".Polaris-Text--subdued", text: "HelpText"
      end
    end
  end

  def test_active_item
    render_inline(Polaris::ActionListComponent.new) do |action_list|
      action_list.item(active: true) { "Item" }
    end

    assert_selector "li > .Polaris-ActionList__Item.Polaris-ActionList--active"
  end

  def test_destructive_item
    render_inline(Polaris::ActionListComponent.new) do |action_list|
      action_list.item(destructive: true) { "Item" }
    end

    assert_selector "li > .Polaris-ActionList__Item.Polaris-ActionList--destructive"
  end
end
