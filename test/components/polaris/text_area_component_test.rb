require "test_helper"

class TextAreaComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_text_area
    render_inline(Polaris::TextAreaComponent.new(
      name: :input_name,
      value: "Multiline\nValue",
      rows: 4,
    ))

    assert_selector ".Polaris-TextField.Polaris-TextField--multiline" do
      assert_selector "textarea.Polaris-TextField__Input[name=input_name][rows=4]"
    end
  end

  def test_character_count
    render_inline(Polaris::TextAreaComponent.new(
      name: :input_name,
      value: "Multiline\nValue",
      rows: 4,
      show_character_count: true,
      maxlength: 40,
    ))

    assert_selector ".Polaris-TextField" do
      assert_selector ".Polaris-TextField__CharacterCount.Polaris-TextField__AlignFieldBottom", text: "15/40"
    end
  end
end
