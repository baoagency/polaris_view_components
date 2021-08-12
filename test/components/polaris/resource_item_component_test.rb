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

  def test_item_with_vertical_alignment
    render_inline(Polaris::ResourceItemComponent.new(vertical_alignment: :center)) do
      "Content"
    end

    assert_selector ".Polaris-ResourceItem" do
      assert_selector ".Polaris-ResourceItem__Container.Polaris-ResourceItem--alignmentCenter"
    end
  end
end
