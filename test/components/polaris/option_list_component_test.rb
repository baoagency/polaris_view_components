require "test_helper"

class OptionListComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_single_choice
    render_inline(Polaris::OptionListComponent.new(title: "TITLE")) do |list|
      list.with_radio_button(label: "Item 1", value: "item_1")
      list.with_radio_button(label: "Item 2", value: "item_2")
    end

    assert_text "Item 1"
    assert_text "Item 2"
  end

  def test_option_prefix
    render_inline(Polaris::OptionListComponent.new) do |list|
      list.with_radio_button(label: "Item 1", value: "item_1") do |button|
        button.with_prefix { "Prefix" }
      end
    end

    assert_text "Item 1"
    assert_text "Prefix"
  end

  def test_option_suffix
    render_inline(Polaris::OptionListComponent.new) do |list|
      list.with_radio_button(label: "Item 1", value: "item_1") do |button|
        button.with_suffix { "Suffix" }
      end
    end

    assert_text "Item 1"
    assert_text "Suffix"
  end

  def test_multi_choice
    render_inline(Polaris::OptionListComponent.new) do |list|
      list.with_checkbox(label: "Item 1", value: "item_1")
      list.with_checkbox(label: "Item 2", value: "item_2")
    end

    assert_text "Item 1"
    assert_text "Item 2"
  end

  def test_custom_option
    render_inline(Polaris::OptionListComponent.new) do |list|
      list.with_option { "CUSTOM_CONTENT" }
    end

    assert_selector "ul > li" do
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

    assert_text "Title 1"
    assert_text "Content 1"
    assert_text "Title 2"
    assert_text "Content 2"
  end
end
