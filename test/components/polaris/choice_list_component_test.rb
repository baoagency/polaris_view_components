require "test_helper"

class ChoiceListComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_single_choice_list
    render_inline(Polaris::ChoiceListComponent.new(title: "Title", name: :input_name)) do |choice|
      choice.radio_button(label: "First Radio", value: "first_radio")
      choice.radio_button(label: "Second Radio", value: "second_radio")
    end

    assert_selector "fieldset.Polaris-ChoiceList" do
      assert_selector "legend.Polaris-ChoiceList__Title", text: "Title"
      assert_selector "ul.Polaris-ChoiceList__Choices" do
        assert_selector "li", count: 2
        assert_selector "li:nth-child(1)" do
          assert_selector ".Polaris-Choice" do
            assert_selector "input[type=radio][name=input_name][value=first_radio]"
            assert_selector ".Polaris-Choice__Label", text: "First Radio"
          end
        end
        assert_selector "li:nth-child(2)" do
          assert_selector ".Polaris-Choice" do
            assert_selector "input[type=radio][name=input_name][value=second_radio]"
            assert_selector ".Polaris-Choice__Label", text: "Second Radio"
          end
        end
      end
    end
  end

  def test_single_choice_list_with_error
    render_inline(Polaris::ChoiceListComponent.new(title: "Title", error: "Error Text")) do |choice|
      choice.radio_button(label: "First Radio", value: "first_radio")
    end

    assert_selector ".Polaris-ChoiceList" do
      assert_selector ".Polaris-ChoiceList__ChoiceError > .Polaris-InlineError", text: "Error Text"
    end
  end

  def test_single_choice_with_children_content
    render_inline(Polaris::ChoiceListComponent.new(title: "Title")) do |choice|
      choice.radio_button(label: "Label", value: "value") { "Children content" }
    end

    assert_selector ".Polaris-ChoiceList > .Polaris-ChoiceList__Choices" do
      assert_selector "li" do
        assert_selector ".Polaris-ChoiceList__ChoiceChildren", text: "Children content"
      end
    end
  end

  def test_multi_choice_list
    render_inline(Polaris::ChoiceListComponent.new(title: "Title", name: :input_name)) do |choice|
      choice.checkbox(label: "First Checkbox", value: "first_checkbox")
      choice.checkbox(label: "Second Checkbox", value: "second_checkbox")
    end

    assert_selector "fieldset.Polaris-ChoiceList" do
      assert_selector "legend.Polaris-ChoiceList__Title", text: "Title"
      assert_selector "ul.Polaris-ChoiceList__Choices" do
        assert_selector "li", count: 2
        assert_selector "li:nth-child(1)" do
          assert_selector ".Polaris-Choice" do
            assert_selector "input[type=checkbox][name='input_name[]'][value=first_checkbox]"
            assert_selector ".Polaris-Choice__Label", text: "First Checkbox"
          end
        end
        assert_selector "li:nth-child(2)" do
          assert_selector ".Polaris-Choice" do
            assert_selector "input[type=checkbox][name='input_name[]'][value=second_checkbox]"
            assert_selector ".Polaris-Choice__Label", text: "Second Checkbox"
          end
        end
      end
    end
  end
end
