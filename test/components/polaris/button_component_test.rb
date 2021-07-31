require "test_helper"

class ButtonComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_basic_button
    render_inline(Polaris::ButtonComponent.new) { "Button" }

    assert_selector "button.Polaris-Button[type=button]" do
      assert_selector ".Polaris-Button__Content > .Polaris-Button__Text", text: "Button"
    end
  end

  def test_outline_button
    render_inline(Polaris::ButtonComponent.new(outline: true)) { "Button" }

    assert_selector "button.Polaris-Button--outline"
  end

  def test_outline_monochrome_button
    render_inline(Polaris::ButtonComponent.new(outline: true, monochrome: true)) { "Button" }

    assert_selector "button.Polaris-Button--outline.Polaris-Button--monochrome"
  end

  def test_plain_button
    render_inline(Polaris::ButtonComponent.new(plain: true)) { "Button" }

    assert_selector "button.Polaris-Button--plain"
  end

  def test_plain_monochrome_button
    render_inline(Polaris::ButtonComponent.new(plain: true, monochrome: true)) { "Button" }

    assert_selector "button.Polaris-Button--plain.Polaris-Button--monochrome"
  end

  def test_plain_monochrome_button_without_underline
    render_inline(Polaris::ButtonComponent.new(plain: true, monochrome: true, remove_underline: true)) { "Button" }

    assert_selector "button.Polaris-Button--plain.Polaris-Button--monochrome.Polaris-Button--removeUnderline" do
      assert_selector ".Polaris-Button__Content" do
        assert_selector ".Polaris-Button__Text.Polaris-Button--removeUnderline", text: "Button"
      end
    end
  end

  def test_plain_destructive_button
    render_inline(Polaris::ButtonComponent.new(plain: true, destructive: true)) { "Button" }

    assert_selector "button.Polaris-Button--plain.Polaris-Button--destructive"
  end

  def test_primary_button
    render_inline(Polaris::ButtonComponent.new(primary: true)) { "Button" }

    assert_selector "button.Polaris-Button--primary"
  end

  def test_destructive_button
    render_inline(Polaris::ButtonComponent.new(destructive: true)) { "Button" }

    assert_selector "button.Polaris-Button--destructive"
  end

  def test_slim_button
    render_inline(Polaris::ButtonComponent.new(size: :slim)) { "Button" }

    assert_selector "button.Polaris-Button--sizeSlim"
  end

  def test_large_button
    render_inline(Polaris::ButtonComponent.new(size: :large)) { "Button" }

    assert_selector "button.Polaris-Button--sizeLarge"
  end

  def test_full_width_button
    render_inline(Polaris::ButtonComponent.new(full_width: true)) { "Button" }

    assert_selector "button.Polaris-Button--fullWidth"
  end

  def test_text_aligned_button
    render_inline(Polaris::ButtonComponent.new(text_align: :center)) { "Button" }

    assert_selector "button.Polaris-Button--textAlignCenter"
  end

  def test_pressed_button
    render_inline(Polaris::ButtonComponent.new(pressed: true)) { "Button" }

    assert_selector "button.Polaris-Button--pressed"
  end

  def test_disabled_button
    render_inline(Polaris::ButtonComponent.new(disabled: true)) { "Button" }

    assert_selector "button.Polaris-Button--disabled[disabled=disabled]"
  end

  def test_loading_button
    render_inline(Polaris::ButtonComponent.new(loading: true)) { "Button" }

    assert_selector "button.Polaris-Button--loading[disabled=disabled]" do
      assert_selector ".Polaris-Button__Spinner"
    end
  end

  def test_text_with_icon_button
    render_inline(Polaris::ButtonComponent.new) do |button|
      button.icon(name: "CirclePlusMajor")
      "Button"
    end

    assert_selector "button.Polaris-Button > .Polaris-Button__Content" do
      assert_selector ".Polaris-Button__Icon > .Polaris-Icon > svg.Polaris-Icon__Svg"
      assert_selector ".Polaris-Button__Text", text: "Button"
    end
  end

  def test_icon_only_button
    render_inline(Polaris::ButtonComponent.new) do |button|
      button.icon(name: "CirclePlusMajor")
    end

    assert_selector "button.Polaris-Button--iconOnly" do
      assert_selector ".Polaris-Button__Icon > .Polaris-Icon"
    end
  end

  def test_external_button
    render_inline(Polaris::ButtonComponent.new(external: true, url: "https://shopify.com")) { "Button" }

    assert_selector "a.Polaris-Button[target='_blank'][href='https://shopify.com']" do
      assert_selector ".Polaris-Button__Content > .Polaris-Button__Text", text: "Button"
    end
  end
end
