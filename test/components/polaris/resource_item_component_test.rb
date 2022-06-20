require "test_helper"

class ResourceItemComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_item
    render_inline(Polaris::ResourceItemComponent.new) do
      "Content"
    end

    assert_selector "li.Polaris-ResourceItem__ListItem" do
      assert_selector ".Polaris-ResourceItem__ItemWrapper" do
        assert_selector ".Polaris-ResourceItem[style='cursor: default;']" do
          assert_selector ".Polaris-ResourceItem__Container" do
            assert_selector ".Polaris-ResourceItem__Content", text: "Content"
          end
        end
      end
    end
  end

  def test_selectable
    render_inline(Polaris::ResourceItemComponent.new(selectable: true)) do |resource_item|
      "Content"
    end

    assert_selector ".Polaris-ResourceItem.Polaris-ResourceItem--selectable"
  end

  def test_persist_actions
    render_inline(Polaris::ResourceItemComponent.new(persist_actions: true)) do |resource_item|
      "Content"
    end

    assert_selector ".Polaris-ResourceItem.Polaris-ResourceItem--persistActions"
  end

  def test_item_with_checkbox
    render_inline(Polaris::ResourceItemComponent.new) do |resource_item|
      resource_item.checkbox(name: "attr[]", value: "val")
      "Content"
    end

    assert_selector ".Polaris-ResourceItem__Container" do
      assert_selector ".Polaris-ResourceItem__Owned.Polaris-ResourceItem__OwnedNoMedia" do
        assert_selector ".Polaris-ResourceItem__Handle > .Polaris-ResourceItem__CheckboxWrapper" do
          assert_selector ".Polaris-Choice.Polaris-Choice--labelHidden" do
            assert_selector "input[type=checkbox]"
          end
        end
      end
    end
  end

  def test_item_with_offset_checkbox
    render_inline(Polaris::ResourceItemComponent.new(offset: true)) do |resource_item|
      resource_item.checkbox(name: "attr[]", value: "val")
      "Content"
    end

    assert_selector ".Polaris-ResourceItem__Owned.Polaris-ResourceItem__Owned--offset"
  end

  def test_item_with_radio_button
    render_inline(Polaris::ResourceItemComponent.new) do |resource_item|
      resource_item.radio_button(name: "attr[]", value: "val")
      "Content"
    end

    assert_selector ".Polaris-ResourceItem__Container" do
      assert_selector ".Polaris-ResourceItem__Owned.Polaris-ResourceItem__OwnedNoMedia" do
        assert_selector ".Polaris-ResourceItem__Handle > .Polaris-ResourceItem__CheckboxWrapper" do
          assert_selector ".Polaris-Choice.Polaris-Choice--labelHidden" do
            assert_selector "input[type=radio]"
          end
        end
      end
    end
  end

  def test_item_with_media
    render_inline(Polaris::ResourceItemComponent.new) do |c|
      c.media { "Media" }
      "Content"
    end

    assert_selector "li.Polaris-ResourceItem__ListItem" do
      assert_selector ".Polaris-ResourceItem__ItemWrapper" do
        assert_selector ".Polaris-ResourceItem[style='cursor: default;']" do
          assert_selector ".Polaris-ResourceItem__Container" do
            assert_selector ".Polaris-ResourceItem__Owned > .Polaris-ResourceItem__Media", text: "Media"
            assert_selector ".Polaris-ResourceItem__Content", text: "Content"
          end
        end
      end
    end
  end

  def test_item_with_shortcut_action
    render_inline(Polaris::ResourceItemComponent.new) do |c|
      c.shortcut_actions do |shortcut_action|
        shortcut_action.button(url: 'https://some-url', content: 'Shortcut action')
      end
      "Content"
    end

    assert_selector ".Polaris-ResourceItem__Container" do
      assert_selector ".Polaris-ResourceItem__Actions" do
        assert_selector ".Polaris-ButtonGroup" do
          assert_selector ".Polaris-ButtonGroup.Polaris-ButtonGroup--segmented" do
            assert_selector ".Polaris-ButtonGroup__Item" do
              assert_selector ".Polaris-Button.Polaris-Button--sizeSlim", text: "Shortcut action"
            end
          end
        end
      end
    end
  end

  def test_item_with_persistent_shortcut_action
    render_inline(Polaris::ResourceItemComponent.new(persist_actions: true)) do |c|
      c.shortcut_actions do |shortcut_action|
        shortcut_action.button(url: 'https://some-url', content: 'Shortcut action')
      end
      "Content"
    end

    assert_selector ".Polaris-ResourceItem__Container" do
      assert_selector ".Polaris-ResourceItem__Actions" do
        assert_selector ".Polaris-ButtonGroup" do
          assert_selector ".Polaris-ButtonGroup__Item.Polaris-ButtonGroup__Item--plain" do
            assert_selector ".Polaris-Button.Polaris-Button--plain", text: "Shortcut action"
          end
        end
      end
      assert_selector ".Polaris-ResourceItem__Disclosure" do
        assert_selector "[data-controller='polaris-popover']"
      end
    end
  end

  def test_item_with_vertical_alignment
    render_inline(Polaris::ResourceItemComponent.new(vertical_alignment: :center)) do
      "Content"
    end

    assert_selector ".Polaris-ResourceItem" do
      assert_selector ".Polaris-ResourceItem__Container.Polaris-ResourceItem--alignmentCenter"
    end
  end
end
