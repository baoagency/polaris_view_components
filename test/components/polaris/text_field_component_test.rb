require "test_helper"

class TextFieldComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_text_field
    render_inline(Polaris::TextFieldComponent.new(
      name: :input_name,
      value: "Value",
      label: "Label"
    ))

    assert_selector "div > .Polaris-Labelled__LabelWrapper" do
      assert_selector ".Polaris-Label" do
        assert_selector "label.Polaris-Label__Text[for=input_name]", text: "Label"
      end
      assert_selector ".Polaris-Connected" do
        assert_selector ".Polaris-Connected__Item.Polaris-Connected__Item--primary" do
          assert_selector ".Polaris-TextField.Polaris-TextField--hasValue" do
            assert_selector "input.Polaris-TextField__Input[name=input_name][value=Value][type=text]"
          end
        end
      end
    end
  end

  def test_number_field
    render_inline(Polaris::TextFieldComponent.new(
      name: :input_name,
      value: "1.34",
      type: :number
    ))

    assert_selector ".Polaris-Connected__Item" do
      assert_selector "input[type=number][value='1.34'][step=1][min=0][max=1000000]"
      assert_selector ".Polaris-TextField__Spinner" do
        assert_selector ".Polaris-TextField__Segment", count: 2
      end
    end
  end

  def test_email_field
    render_inline(Polaris::TextFieldComponent.new(
      name: :input_name,
      type: :email,
      label: "Label"
    ))

    assert_selector ".Polaris-TextField" do
      assert_selector "input[name=input_name][type=email]"
    end
  end

  def test_hidden_label
    render_inline(Polaris::TextFieldComponent.new(
      name: :input_name,
      label: "Label",
      label_hidden: true
    ))

    assert_selector ".Polaris-Labelled--hidden"
  end

  def test_label_action
    render_inline(Polaris::TextFieldComponent.new(
      name: :input_name,
      label: "Label",
      label_action: {url: "/action", content: "Label Action"}
    ))

    assert_selector ".Polaris-Labelled__LabelWrapper" do
      assert_selector ".Polaris-Labelled__Action" do
        assert_selector "a.Polaris-Button.Polaris-Button--plain[href='/action']", text: "Label Action"
      end
    end
  end

  def test_alignment
    render_inline(Polaris::TextFieldComponent.new(
      name: :input_name,
      label: "Label",
      align: :right
    ))

    assert_selector "input.Polaris-TextField__Input.Polaris-TextField__Input--alignRight"
  end

  def test_placeholder
    render_inline(Polaris::TextFieldComponent.new(
      name: :input_name,
      label: "Label",
      placeholder: "Placeholder"
    ))

    assert_selector "input.Polaris-TextField__Input[placeholder=Placeholder]"
  end

  def test_help_text
    render_inline(Polaris::TextFieldComponent.new(
      name: :input_name,
      label: "Label",
      help_text: "Help Text"
    ))

    assert_selector ".Polaris-Labelled__HelpText", text: "Help Text"
  end

  def test_prefix
    render_inline(Polaris::TextFieldComponent.new(
      name: :input_name,
      label: "Label",
      prefix: "Prefix"
    ))

    assert_selector ".Polaris-TextField > .Polaris-TextField__Prefix", text: "Prefix"
  end

  def test_suffix
    render_inline(Polaris::TextFieldComponent.new(
      name: :input_name,
      label: "Label",
      suffix: "Suffix"
    ))

    assert_selector ".Polaris-TextField" do
      assert_selector "input.Polaris-TextField__Input.Polaris-TextField__Input--suffixed"
      assert_selector ".Polaris-TextField__Suffix", text: "Suffix"
    end
  end

  def test_prefix_suffix_icon_shorthand
    render_inline(Polaris::TextFieldComponent.new(
      name: :input_name,
      label: "Label"
    )) do |c|
      c.with_prefix(icon: "ReceiptDollarFilledIcon")
      c.with_suffix(icon: "EmailIcon")
    end

    assert_selector ".Polaris-TextField > .Polaris-TextField__Prefix > .Polaris-Icon"
    assert_selector ".Polaris-TextField > .Polaris-TextField__Suffix > .Polaris-Icon"
  end

  def test_prefix_suffix_slots
    render_inline(Polaris::TextFieldComponent.new(
      name: :input_name,
      label: "Label"
    )) do |c|
      c.with_prefix { "Prefix" }
      c.with_suffix { "Suffix" }
    end

    assert_selector ".Polaris-TextField > .Polaris-TextField__Prefix", text: "Prefix"
    assert_selector ".Polaris-TextField > .Polaris-TextField__Suffix", text: "Suffix"
  end

  def test_connected_fields
    render_inline(Polaris::TextFieldComponent.new(
      name: :input_name,
      label: "Label"
    )) do |text_field|
      text_field.with_connected_left { "Left Content" }
      text_field.with_connected_right { "Right Content" }
    end

    assert_selector ".Polaris-Connected" do
      assert_selector ".Polaris-Connected__Item", count: 3
      assert_selector ".Polaris-Connected__Item:nth-child(1)", text: "Left Content"
      assert_selector ".Polaris-Connected__Item.Polaris-Connected__Item--primary:nth-child(2)"
      assert_selector ".Polaris-Connected__Item:nth-child(3)", text: "Right Content"
    end
  end

  def test_error
    render_inline(Polaris::TextFieldComponent.new(
      name: :input_name,
      label: "Label",
      error: true
    ))

    assert_selector ".Polaris-TextField.Polaris-TextField--error"
  end

  def test_inline_error
    render_inline(Polaris::TextFieldComponent.new(
      name: :input_name,
      label: "Label",
      error: "Inline Error"
    ))

    assert_selector ".Polaris-TextField.Polaris-TextField--error"
    assert_selector ".Polaris-Labelled__Error > .Polaris-InlineError", text: "Inline Error"
  end

  def test_disabled
    render_inline(Polaris::TextFieldComponent.new(
      name: :input_name,
      label: "Label",
      disabled: true
    ))

    assert_selector ".Polaris-TextField.Polaris-TextField--disabled" do
      assert_selector "input[disabled=disabled]"
    end
  end

  def test_readonly
    render_inline(Polaris::TextFieldComponent.new(
      name: :input_name,
      label: "Label",
      readonly: true
    ))

    assert_selector ".Polaris-TextField.Polaris-TextField--readOnly" do
      assert_selector "input[readonly=readonly]"
    end
  end

  def test_character_count
    render_inline(Polaris::TextFieldComponent.new(
      name: :input_name,
      value: "1234567890",
      label: "Label",
      show_character_count: true,
      maxlength: 20
    ))

    assert_selector ".Polaris-TextField" do
      assert_selector ".Polaris-TextField__CharacterCount", text: "10/20"
    end
  end

  def test_clear_button
    render_inline(Polaris::TextFieldComponent.new(
      name: :input_name,
      label: "Label",
      clear_button: true
    ))

    assert_selector ".Polaris-TextField" do
      assert_selector ".Polaris-TextField__ClearButton"
    end
  end

  def test_monospaced_font
    render_inline(Polaris::TextFieldComponent.new(
      name: :input_name,
      label: "Label",
      monospaced: true
    ))

    assert_selector "input.Polaris-TextField--monospaced"
  end

  def test_default_text_area
    render_inline(Polaris::TextFieldComponent.new(
      name: :input_name,
      value: "Multiline\nValue",
      multiline: true,
      rows: 4
    ))

    assert_selector ".Polaris-TextField.Polaris-TextField--multiline" do
      assert_selector "textarea.Polaris-TextField__Input[name=input_name][rows=4]"
    end
  end

  def test_multiline_character_count
    render_inline(Polaris::TextFieldComponent.new(
      name: :input_name,
      value: "Multiline\nValue",
      multiline: true,
      rows: 4,
      show_character_count: true,
      maxlength: 40
    ))

    assert_selector ".Polaris-TextField" do
      assert_selector ".Polaris-TextField__CharacterCount.Polaris-TextField__AlignFieldBottom", text: "15/40"
    end
  end

  def test_clear_errors_on_focus
    render_inline(Polaris::TextFieldComponent.new(
      name: :input_name,
      value: "Value",
      label: "Label",
      clear_errors_on_focus: true
    ))

    assert_selector "input[name=input_name][data-action~='click->polaris-text-field#clearErrorMessages']"

    render_inline(Polaris::TextFieldComponent.new(
      name: :input_name,
      value: "Value",
      label: "Label",
      clear_errors_on_focus: true,
      input_options: {data: {action: "custom#action"}}
    ))

    assert_selector "input[name=input_name][data-action~='click->polaris-text-field#clearErrorMessages']"
  end
end
