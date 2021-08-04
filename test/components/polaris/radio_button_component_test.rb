require "test_helper"

class RadioButtonComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_checkbox
    render_inline(Polaris::RadioButtonComponent.new(name: "input_name", label: "Label"))

    assert_selector "div > label.Polaris-Choice" do
      assert_selector ".Polaris-Choice__Control > .Polaris-RadioButton" do
        assert_selector "input[type=radio][name=input_name][class=Polaris-RadioButton__Input]"
        assert_selector ".Polaris-RadioButton__Backdrop"
      end
      assert_selector ".Polaris-Choice__Label", text: "Label"
    end
  end

  def test_checkbox_with_help_text
    render_inline(Polaris::RadioButtonComponent.new(label: "Label", help_text: "Help Text"))

    assert_selector "div > .Polaris-Choice__Descriptions" do
      assert_selector ".Polaris-Choice__HelpText", text: "Help Text"
    end
  end
end
