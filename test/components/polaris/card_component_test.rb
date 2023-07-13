require "test_helper"

class CardComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_renders_default
    render_inline(Polaris::CardComponent.new(title: "Card")) { "Content" }

    assert_selector ".Polaris-LegacyCard"
    assert_selector ".Polaris-LegacyCard__Header"
    assert_selector ".Polaris-LegacyCard__Section"
  end

  def test_renders_card_with_multiple_sections
    render_inline(Polaris::CardComponent.new(title: "Card")) do |card|
      card.with_section { "Section 1" }
      card.with_section { "Section 2" }
    end

    assert_selector ".Polaris-LegacyCard__Section", text: "Section 1"
    assert_selector ".Polaris-LegacyCard__Section", text: "Section 2"
  end

  def test_renders_card_with_multiple_title_sections
    render_inline(Polaris::CardComponent.new(title: "Card")) do |card|
      card.with_section(title: "Title 1") { "Section 1" }
      card.with_section(title: "Title 2") { "Section 2" }
    end

    assert_selector ".Polaris-LegacyCard__SectionHeader", text: "Title 1"
    assert_selector ".Polaris-LegacyCard__SectionHeader", text: "Title 2"
  end

  def test_renders_card_section_with_action
    render_inline(Polaris::CardComponent.new(title: "Card")) do |card|
      card.with_section { "Section 1" }
      card.with_section(title: "Title 1", actions: [{content: "Action", url: "https://bao.agency"}]) { "Section 2" }
    end

    assert_selector ".Polaris-LegacyCard__SectionHeader .Polaris-Button", text: "Action"
  end

  def test_renders_card_with_separate_header
    render_inline(Polaris::CardComponent.new(title: "Card")) do |card|
      card.with_header(title: "Separate header", actions: [{content: "Action", url: "https://bao.agency"}])

      card.with_section { "Section 1" }
      card.with_section { "Section 2" }
    end

    assert_selector ".Polaris-LegacyCard__Header", text: "Separate header"
    assert_selector ".Polaris-LegacyCard__Header .Polaris-Button", text: "Action"
  end

  def test_renders_subdued_card_for_secondary_content
    render_inline(Polaris::CardComponent.new(title: "Subdued", subdued: true)) { "Body" }

    assert_selector ".Polaris-LegacyCard--subdued"
  end

  def test_renders_card_with_subdued_section
    render_inline(Polaris::CardComponent.new(title: "Card")) do |card|
      card.with_section { "Section 1" }
      card.with_section(subdued: true) { "Section 2" }
    end

    assert_selector ".Polaris-LegacyCard__Section--subdued"
  end

  def test_renders_card_with_flushed_section
    render_inline(Polaris::CardComponent.new(title: "Card")) do |card|
      card.with_section { "Section 1" }
      card.with_section(flush: true) { "Section 2" }
    end

    assert_selector ".Polaris-LegacyCard__Section--flush"
  end

  def test_renders_card_with_destructive_action
    render_inline(Polaris::CardComponent.new(title: "Card")) do |card|
      card.with_section { "Section 1" }
      card.with_section(title: "Title 1", actions: [{content: "Action", url: "https://bao.agency", destructive: true}]) { "Section 2" }
    end

    assert_selector ".Polaris-LegacyCard__SectionHeader .Polaris-Button--destructive", text: "Action"
  end

  def test_renders_card_with_subsection
    render_inline(Polaris::CardComponent.new(title: "Card")) do |card|
      card.with_section do |section|
        section.with_subsection { "Subsection" }
      end
    end

    assert_selector ".Polaris-LegacyCard__Subsection", text: "Subsection"
  end

  def test_renders_card_with_header_actions
    render_inline(Polaris::CardComponent.new(
      title: "Card",
      actions: [{content: "Header action", url: "https://bao.agency"}]
    )) { "Body" }

    assert_selector ".Polaris-LegacyCard__Header .Polaris-Button"
  end

  def test_renders_card_with_footer_actions
    render_inline(Polaris::CardComponent.new(title: "Card")) do |card|
      card.with_primary_footer_action(url: "https://bao.agency") { "Primary Action" }
      card.with_secondary_footer_action(url: "https://bao.agency") { "Secondary Action" }
    end

    assert_selector ".Polaris-LegacyCard__Footer .Polaris-ButtonGroup__Item:nth-child(1) .Polaris-Button__Text", text: "Secondary Action"
    assert_selector ".Polaris-LegacyCard__Footer .Polaris-ButtonGroup__Item:nth-child(2) .Polaris-Button--primary", text: "Primary Action"
  end

  def test_renders_card_with_destructive_footer_action
    render_inline(Polaris::CardComponent.new(title: "Card")) do |card|
      card.with_primary_footer_action(url: "https://bao.agency") { "Primary Action" }
      card.with_secondary_footer_action(url: "https://bao.agency", destructive: true) { "Primary Action" }
    end

    assert_selector ".Polaris-LegacyCard__Footer .Polaris-ButtonGroup__Item:nth-child(1) .Polaris-Button--destructive"
    assert_selector ".Polaris-LegacyCard__Footer .Polaris-ButtonGroup__Item:nth-child(2) .Polaris-Button--primary"
  end

  def test_unsectioned_content
    render_inline(Polaris::CardComponent.new(title: "Card")) do |card|
      card.with_section { "Sectioned content" }
      "Unsectioned content"
    end

    assert_selector ".Polaris-LegacyCard" do
      assert_selector ".Polaris-LegacyCard__Header:nth-child(1)"
      assert_selector ".Polaris-LegacyCard__Section:nth-child(2)", text: "Sectioned content"
      assert_selector ":nth-child(3)", text: "Unsectioned content"
    end
  end

  def test_tabs
    render_inline(Polaris::CardComponent.new) do |card|
      card.with_tabs do |tabs|
        tabs.with_tab(title: "Tab Title")
      end
    end

    assert_selector ".Polaris-LegacyCard > .Polaris-LegacyTabs__Wrapper > ul.Polaris-LegacyTabs" do
      assert_selector "li.Polaris-LegacyTabs__TabContainer > button.Polaris-LegacyTabs__Tab", text: "Tab Title"
    end
  end
end
