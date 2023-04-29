require "test_helper"

class ButtonComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_tag
    render_inline(Polaris::TagComponent.new) { "Content" }

    assert_selector "span.Polaris-Tag" do
      assert_selector "span.Polaris-TagText", text: "Content"
    end
  end

  def test_clickable_tag
    render_inline(Polaris::TagComponent.new(clickable: true)) { "Content" }

    assert_selector "button.Polaris-Tag.Polaris-Tag--clickable"
  end

  def test_disabled_tag
    render_inline(Polaris::TagComponent.new(disabled: true)) { "Content" }

    assert_selector "span.Polaris-Tag.Polaris-Tag--disabled"
  end

  def test_with_removable_button
    render_inline Polaris::TagComponent.new do |tag|
      tag.with_remove_button(data: {})
      "Content"
    end

    assert_selector "span.Polaris-Tag.Polaris-Tag--removable" do
      assert_selector "button.Polaris-Tag__Button" do
        assert_selector "span.Polaris-Icon"
      end
      assert_selector "span.Polaris-TagText", text: "Content"
    end
  end
end
