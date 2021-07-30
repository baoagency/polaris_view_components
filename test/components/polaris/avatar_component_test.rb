require "test_helper"

class AvatarComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_renders_default_avatar
    render_inline(Polaris::AvatarComponent.new)

    assert_selector "span.Polaris-Avatar.Polaris-Avatar--sizeMedium.Polaris-Avatar--styleOne[role=img]" do
      assert_selector "svg.Polaris-Avatar__Svg"
    end
  end

  def test_renders_customer_avatar
    render_inline(Polaris::AvatarComponent.new(customer: true, name: "Bob"))

    assert_selector "span.Polaris-Avatar[aria-label='Bob']"
    assert_no_selector "span.Polaris-Avatar--styleOne"
  end

  def test_renders_initials
    render_inline(Polaris::AvatarComponent.new(initials: "KP"))

    assert_selector "span.Polaris-Avatar.Polaris-Avatar--styleOne" do
      assert_selector ".Polaris-Avatar__Initials > .Polaris-Avatar__Svg > text", text: "KP"
    end
  end

  def test_renders_image
    render_inline(Polaris::AvatarComponent.new(source: "/image.png"))

    assert_selector "span.Polaris-Avatar.Polaris-Avatar--hasImage" do
      assert_selector "img.Polaris-Avatar__Image[src='/image.png']"
    end
  end
end
