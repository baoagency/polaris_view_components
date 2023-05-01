require "test_helper"

class ChoiceListComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_single_choice_list
    render_inline(Polaris::ChoiceListComponent.new(title: "Title", name: :input_name)) do |choice|
      choice.with_radio_button(label: "First Radio", value: "first_radio")
      choice.with_radio_button(label: "Second Radio", value: "second_radio")
    end

    assert_selector "legend", text: "Title"
    assert_selector "ul" do
      assert_selector "li", count: 2
      assert_selector "li:nth-child(1)" do
        assert_selector "input[type=radio][name=input_name][value=first_radio]"
        assert_text "First Radio"
      end
      assert_selector "li:nth-child(2)" do
        assert_selector "input[type=radio][name=input_name][value=second_radio]"
        assert_text "Second Radio"
      end
    end
  end

  def test_single_choice_list_with_error
    render_inline(Polaris::ChoiceListComponent.new(title: "Title", error: "Error Text")) do |choice|
      choice.with_radio_button(label: "First Radio", value: "first_radio")
    end

    assert_selector ".Polaris-InlineError", text: "Error Text"
  end

  def test_single_choice_with_children_content
    render_inline(Polaris::ChoiceListComponent.new(title: "Title")) do |choice|
      choice.with_radio_button(label: "Label", value: "value") { "Children content" }
    end

    assert_selector "li" do
      assert_text "Children content"
    end
  end

  def test_multi_choice_list
    render_inline(Polaris::ChoiceListComponent.new(title: "Title", name: :input_name)) do |choice|
      choice.with_checkbox(label: "First Checkbox", value: "first_checkbox")
      choice.with_checkbox(label: "Second Checkbox", value: "second_checkbox")
    end

    assert_selector "legend", text: "Title"
    assert_selector "ul" do
      assert_selector "li", count: 2
      assert_selector "li:nth-child(1)" do
        assert_selector "input[type=checkbox][name='input_name[]'][value=first_checkbox]"
        assert_text "First Checkbox"
      end
      assert_selector "li:nth-child(2)" do
        assert_selector "input[type=checkbox][name='input_name[]'][value=second_checkbox]"
        assert_text "Second Checkbox"
      end
    end
  end
end
