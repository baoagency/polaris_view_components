require "test_helper"

class SelectComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_select_with_hash
    render_inline(Polaris::SelectComponent.new(
      name: :input_name,
      label: "Input Label",
      options: { "Option 1" => "option1", "Option 2" => "option2" },
      selected: "option2",
    ))

    assert_selector "div" do
      assert_selector ".Polaris-Labelled__LabelWrapper > .Polaris-Label" do
        assert_selector "label.Polaris-Label__Text[for=input_name]", text: "Input Label"
      end
      assert_selector ".Polaris-Select[data-controller='polaris-select']" do
        assert_selector "select.Polaris-Select__Input[name=input_name][data-action='polaris-select#update']" do
          assert_selector "option", count: 2
          assert_selector "option[value=option1]:nth-child(1)", text: "Option 1"
          assert_selector "option[value=option2]:nth-child(2)", text: "Option 2"
        end
        assert_selector ".Polaris-Select__Content" do
          assert_selector ".Polaris-Select__SelectedOption[data-polaris-select-target='selectedOption']", text: "Option 2"
          assert_selector ".Polaris-Select__Icon > .Polaris-Icon"
          assert_selector ".Polaris-Select__Backdrop"
        end
      end
    end
  end

  def test_select_with_array
    render_inline(Polaris::SelectComponent.new(
      name: :input_name,
      label: "Input Label",
      options: [["Option 1", "option1"], ["Option 2", "option2"]],
    ))

    assert_selector "select.Polaris-Select__Input" do
      assert_selector "option", count: 2
      assert_selector "option[value=option1]:nth-child(1)", text: "Option 1"
      assert_selector "option[value=option2]:nth-child(2)", text: "Option 2"
    end
  end

  def test_inline_label
    render_inline(Polaris::SelectComponent.new(
      name: :input_name,
      label: "Input Label",
      label_inline: true,
      options: [["Option 1", "option1"]],
    ))

    assert_selector ".Polaris-Labelled--hidden" do
      assert_selector ".Polaris-Select__Content" do
        assert_selector ".Polaris-Select__InlineLabel", text: "Input Label"
      end
    end
  end

  def test_label_action
    render_inline(Polaris::SelectComponent.new(
      name: :input_name,
      label: "Input Label",
      label_action: { url: "/action", content: "Label Action" },
      options: [["Option 1", "option1"]],
    ))

    assert_selector ".Polaris-Labelled__LabelWrapper" do
      assert_selector ".Polaris-Labelled__Action" do
        assert_selector "a.Polaris-Button.Polaris-Button--plain[href='/action']", text: "Label Action"
      end
    end
  end

  def test_disabled
    render_inline(Polaris::SelectComponent.new(
      name: :input_name,
      label: "Input Label",
      disabled: true,
      options: [["Option 1", "option1"]],
    ))

    assert_selector ".Polaris-Select.Polaris-Select--disabled" do
      assert_selector "select[disabled=disabled]"
      assert_selector ".Polaris-Select__Content[aria-disabled=true]"
    end
  end

  def test_required
    render_inline(Polaris::SelectComponent.new(
      name: :input_name,
      label: "Input Label",
      required: true,
      options: [["Option 1", "option1"]],
    ))

    assert_selector ".Polaris-Labelled__LabelWrapper > .Polaris-Label" do
      assert_selector "label.Polaris-Label__Text.Polaris-Label__RequiredIndicator"
    end
  end

  def test_with_error
    render_inline(Polaris::SelectComponent.new(
      name: :input_name,
      label: "Input Label",
      error: true,
      options: [["Option 1", "option1"]],
    ))

    assert_selector ".Polaris-Select.Polaris-Select--error"
  end

  def test_with_inline_error
    render_inline(Polaris::SelectComponent.new(
      name: :input_name,
      label: "Input Label",
      error: "Inline Error",
      options: [["Option 1", "option1"]],
    ))

    assert_selector ".Polaris-Select.Polaris-Select--error"
    assert_selector ".Polaris-Labelled__Error" do
      assert_selector ".Polaris-InlineError", text: "Inline Error"
    end
  end
end
