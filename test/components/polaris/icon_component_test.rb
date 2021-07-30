require "test_helper"

class IconComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_renders_default_icon
    render_inline(Polaris::IconComponent.new(name: "CirclePlusMinor"))

    assert_selector "span.Polaris-Icon" do
      assert_selector "svg.Polaris-Icon__Svg"
    end
  end

  def test_renders_colored_icon
    render_inline(Polaris::IconComponent.new(name: "CirclePlusMinor", color: :critical))

    assert_selector "span.Polaris-Icon.Polaris-Icon--colorCritical.Polaris-Icon--applyColor" do
      assert_selector "svg.Polaris-Icon__Svg"
    end
  end

  def test_renders_icon_with_backdrop
    render_inline(Polaris::IconComponent.new(name: "CirclePlusMinor", backdrop: true))

    assert_selector "span.Polaris-Icon.Polaris-Icon--hasBackdrop" do
      assert_selector "svg.Polaris-Icon__Svg"
    end
  end

  def test_renders_user_icon
    render_inline(Polaris::IconComponent.new) do
      "<svg data-icon='custom' viewBox='0 0 20 20' xmlns='http://www.w3.org/2000/svg'><path d='M10.707 17.707l5-5a.999.999 0 1 0-1.414-1.414L11 14.586V3a1 1 0 1 0-2 0v11.586l-3.293-3.293a.999.999 0 1 0-1.414 1.414l5 5a.999.999 0 0 0 1.414 0' /></svg>"
    end

    assert_selector "span.Polaris-Icon" do
      assert_selector "img.Polaris-Icon__Img"
    end
  end
end
