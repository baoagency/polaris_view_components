require "test_helper"

class CheckboxComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_checkbox
    render_inline(Polaris::CheckboxComponent.new(name: "input_name", label: "Label"))

    assert_selector "div > label.Polaris-Choice" do
      assert_selector ".Polaris-Choice__Control > .Polaris-Checkbox" do
        assert_selector "input[type=checkbox][name=input_name][class=Polaris-Checkbox__Input]"
        assert_selector ".Polaris-Checkbox__Backdrop"
        assert_selector ".Polaris-Checkbox__Icon > .Polaris-Icon"
      end
      assert_selector ".Polaris-Choice__Label", text: "Label"
    end
  end

  def test_checkbox_with_help_text
    render_inline(Polaris::CheckboxComponent.new(label: "Label", help_text: "Help Text"))

    assert_selector "div > .Polaris-Choice__Descriptions" do
      assert_selector ".Polaris-Choice__HelpText", text: "Help Text"
    end
  end

  def test_checkbox_with_error
    render_inline(Polaris::CheckboxComponent.new(label: "Label", error: "Error Text"))

    assert_selector "div > label.Polaris-Choice" do
      assert_selector ".Polaris-Choice__Control > .Polaris-Checkbox--error"
    end
    assert_selector "div > .Polaris-Choice__Descriptions" do
      assert_selector ".Polaris-Choice__Error > .Polaris-InlineError", text: "Error Text"
    end
  end

  def test_indeterminate_checkbox
    render_inline(Polaris::CheckboxComponent.new(label: "Label", checked: :indeterminate))

    assert_selector "input.Polaris-Checkbox__Input--indeterminate[type=checkbox][indeterminate]"
    assert_no_selector "[form]"
  end

  def test_remote_form
    render_inline(Polaris::CheckboxComponent.new(form: :form_with_an_id))

    assert_selector "[form=form_with_an_id]"
  end
end
