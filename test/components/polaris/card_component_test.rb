require "test_helper"

class CardComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_renders_default
    render_inline(Polaris::CardComponent.new(title: "Card")) { "Content" }

    assert_selector ".Polaris-Card"
    assert_selector ".Polaris-Card__Header"
    assert_selector ".Polaris-Card__Section"
  end

  def test_renders_card_with_multiple_sections
    render_inline(Polaris::CardComponent.new(title: "Card")) do |card|
      card.section { "Section 1" }
      card.section { "Section 2" }
    end

    assert_selector ".Polaris-Card__Section", text: "Section 1"
    assert_selector ".Polaris-Card__Section", text: "Section 2"
  end

  def test_renders_card_with_multiple_title_sections
    render_inline(Polaris::CardComponent.new(title: "Card")) do |card|
      card.section(title: "Title 1") { "Section 1" }
      card.section(title: "Title 2") { "Section 2" }
    end

    assert_selector ".Polaris-Card__SectionHeader", text: "Title 1"
    assert_selector ".Polaris-Card__SectionHeader", text: "Title 2"
  end

  def test_renders_card_section_with_action
    render_inline(Polaris::CardComponent.new(title: "Card")) do |card|
      card.section { "Section 1" }
      card.section(title: "Title 1", actions: [{ content: "Action", url: "https://bao.agency" }]) { "Section 2" }
    end

    assert_selector ".Polaris-Card__SectionHeader .Polaris-Button", text: "Action"
  end

  def test_renders_card_with_separate_header
    render_inline(Polaris::CardComponent.new(title: "Card")) do |card|
      card.header(title: "Separate header", actions: [{ content: "Action", url: "https://bao.agency" }])

      card.section { "Section 1" }
      card.section { "Section 2" }
    end

    assert_selector ".Polaris-Card__Header .Polaris-Heading", text: "Separate header"
    assert_selector ".Polaris-Card__Header .Polaris-Button", text: "Action"
  end

  def test_renders_subdued_card_for_secondary_content
    render_inline(Polaris::CardComponent.new(title: "Subdued", subdued: true)) { "Body" }

    assert_selector ".Polaris-Card--subdued"
  end

  def test_renders_card_with_subdued_section
    render_inline(Polaris::CardComponent.new(title: "Card")) do |card|
      card.section { "Section 1" }
      card.section(subdued: true) { "Section 2" }
    end

    assert_selector ".Polaris-Card__Section--subdued"
  end

  def test_renders_card_with_flushed_section
    render_inline(Polaris::CardComponent.new(title: "Card")) do |card|
      card.section { "Section 1" }
      card.section(flush: true) { "Section 2" }
    end

    assert_selector ".Polaris-Card__Section--flush"
  end

  def test_renders_card_with_destructive_action
    render_inline(Polaris::CardComponent.new(title: "Card")) do |card|
      card.section { "Section 1" }
      card.section(title: "Title 1", actions: [{ content: "Action", url: "https://bao.agency", destructive: true }]) { "Section 2" }
    end

    assert_selector ".Polaris-Card__SectionHeader .Polaris-Button--destructive", text: "Action"
  end

  def test_renders_card_with_subsection
    render_inline(Polaris::CardComponent.new(title: "Card")) do |card|
      card.section do |section|
        section.subsection { "Subsection" }
      end
    end

    assert_selector ".Polaris-Card__Subsection", text: "Subsection"
  end

  def test_renders_card_with_header_actions
    render_inline(Polaris::CardComponent.new(
      title: "Card",
      actions: [{ content: "Header action", url: "https://bao.agency" }]
    )) { "Body" }

    assert_selector ".Polaris-Card__Header .Polaris-Button"
  end

  def test_renders_card_with_footer_actions
    render_inline(Polaris::CardComponent.new(
      title: "Card",
      primary_footer_action: { content: "Primary footer action", url: "https://bao.agency" },
      secondary_footer_actions: [{ content: "Secondary footer action", url: "https://bao.agency" }]
    )) { "Body" }

    assert_selector ".Polaris-Card__Footer .Polaris-ButtonGroup__Item:nth-child(1) .Polaris-Button__Text", text: "Secondary footer action"
    assert_selector ".Polaris-Card__Footer .Polaris-ButtonGroup__Item:nth-child(2) .Polaris-Button--primary"
  end

  def test_renders_card_with_destructive_footer_action
    render_inline(Polaris::CardComponent.new(
      title: "Card",
      primary_footer_action: { content: "Primary footer action", url: "https://bao.agency" },
      secondary_footer_actions: [{
        content: "Secondary footer action",
        url: "https://bao.agency",
        destructive: true,
      }]
    )) { "Body" }

    assert_selector ".Polaris-Card__Footer .Polaris-ButtonGroup__Item:nth-child(1) .Polaris-Button--destructive"
    assert_selector ".Polaris-Card__Footer .Polaris-ButtonGroup__Item:nth-child(2) .Polaris-Button--primary"
  end
end
