require "test_helper"

class ActionListComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_single_choice
    render_inline(Polaris::OptionListComponent.new(title: "TITLE")) do |list|
      list.with_radio_button(label: "Item 1", value: "item_1")
      list.with_radio_button(label: "Item 2", value: "item_2")
    end

    assert_selector "ul.Polaris-OptionList" do
      assert_selector "p.Polaris-OptionList__Title", text: "TITLE"
      assert_selector "ul.Polaris-OptionList__Options" do
        assert_selector "li.Polaris-OptionList-Option", count: 2
        assert_selector "li:nth-child(1)" do
          assert_selector "label.Polaris-OptionList-Option__SingleSelectOption" do
            assert_selector "input[type=radio][value=item_1]"
            assert_text "Item 1"
          end
        end
        assert_selector "li:nth-child(2)" do
          assert_selector "label.Polaris-OptionList-Option__SingleSelectOption" do
            assert_selector "input[type=radio][value=item_2]"
            assert_text "Item 2"
          end
        end
      end
    end
  end

  def test_multi_choice
    render_inline(Polaris::OptionListComponent.new) do |list|
      list.with_checkbox(label: "Item 1", value: "item_1")
      list.with_checkbox(label: "Item 2", value: "item_2")
    end

    assert_selector "ul.Polaris-OptionList" do
      assert_selector "ul.Polaris-OptionList__Options" do
        assert_selector "li.Polaris-OptionList-Option", count: 2
        assert_selector "li:nth-child(1)" do
          assert_selector "label.Polaris-OptionList-Option__Label" do
            assert_selector ".Polaris-OptionList-Option__Checkbox > .Polaris-OptionList-Checkbox" do
              assert_selector "input[type=checkbox][value=item_1].Polaris-OptionList-Checkbox__Input"
              assert_selector ".Polaris-OptionList-Checkbox__Icon > .Polaris-Icon"
            end
            assert_text "Item 1"
          end
        end
        assert_selector "li:nth-child(2)" do
          assert_selector "label.Polaris-OptionList-Option__Label" do
            assert_selector ".Polaris-OptionList-Option__Checkbox > .Polaris-OptionList-Checkbox" do
              assert_selector "input[type=checkbox][value=item_1]"
            end
            assert_text "Item 2"
          end
        end
      end
    end
  end

  def test_custom_option
    render_inline(Polaris::OptionListComponent.new) do |list|
      list.with_option { "CUSTOM_CONTENT" }
    end

    assert_selector "ul.Polaris-OptionList__Options > li" do
      assert_selector ".Polaris-OptionList-Option__Label", text: "CUSTOM_CONTENT"
    end
  end

  def test_multiple_sections
    render_inline(Polaris::OptionListComponent.new) do |list|
      list.with_section(title: "Title 1") do |section|
        section.with_option { "Content 1" }
      end
      list.with_section(title: "Title 2") do |section|
        section.with_option { "Content 2" }
      end
    end

    assert_selector ".Polaris-OptionList" do
      assert_selector "ul.Polaris-OptionList__Options", count: 2
      assert_selector "li:nth-child(1)" do
        assert_text "Title 1"
        assert_text "Content 1"
      end
      assert_selector "li:nth-child(2)" do
        assert_text "Title 2"
        assert_text "Content 2"
      end
    end
  end
end
