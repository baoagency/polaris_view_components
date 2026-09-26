require "test_helper"

class CardComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_renders_default
    render_inline(Polaris::CardComponent.new(title: "Card")) { "Content" }

    assert_selector ".Polaris-LegacyCard"
    assert_selector ".Polaris-LegacyCard > .Polaris-LegacyCard__Header", text: "Card"
    assert_selector ".Polaris-LegacyCard__Header + .Polaris-LegacyCard__Surface > .Polaris-LegacyCard__Section", text: "Content"
    assert_no_selector ".Polaris-LegacyCard__Surface .Polaris-LegacyCard__Header"
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
    assert_no_selector ".Polaris-LegacyCard__SectionHeader .Polaris-Button--plain"
  end

  def test_renders_card_with_separate_header
    render_inline(Polaris::CardComponent.new(title: "Card")) do |card|
      card.with_header(title: "Separate header", actions: [{content: "Action", url: "https://bao.agency"}])

      card.with_section { "Section 1" }
      card.with_section { "Section 2" }
    end

    assert_selector ".Polaris-LegacyCard > .Polaris-LegacyCard__Header", text: "Separate header"
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
    assert_no_selector ".Polaris-LegacyCard__Header .Polaris-Button--plain"
  end

  def test_card_actions_preserve_explicit_button_styles
    actions = [
      {content: "Primary", primary: true},
      {content: "Plain", plain: true}
    ]
    render_inline(Polaris::CardComponent.new(title: "Card", actions: actions)) do |card|
      card.with_section(title: "Section", actions: actions) { "Body" }
    end

    [".Polaris-LegacyCard__Header", ".Polaris-LegacyCard__SectionHeader"].each do |header|
      assert_selector "#{header} .Polaris-Button--primary:not(.Polaris-Button--plain)", text: "Primary"
      assert_selector "#{header} .Polaris-Button--plain", text: "Plain"
    end
  end

  def test_renders_card_with_right_aligned_footer_actions
    render_inline(Polaris::CardComponent.new(title: "Card", footer_action_alignment: :right)) do |card|
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

    assert_selector ".Polaris-LegacyCard__Footer .Polaris-ButtonGroup__Item:nth-child(1) .Polaris-Button--primary"
    assert_selector ".Polaris-LegacyCard__Footer .Polaris-ButtonGroup__Item:nth-child(2) .Polaris-Button--destructive"
  end

  def test_unsectioned_content
    render_inline(Polaris::CardComponent.new(title: "Card")) do |card|
      card.with_section { "Sectioned content" }
      "Unsectioned content"
    end

    assert_selector ".Polaris-LegacyCard" do
      assert_selector ".Polaris-LegacyCard__Header:nth-child(1)"
      assert_selector ".Polaris-LegacyCard__Surface" do
        assert_selector ".Polaris-LegacyCard__Section:nth-child(1)", text: "Sectioned content"
        assert_selector ".Polaris-LegacyCard__Section:nth-child(2)", text: "Unsectioned content"
      end
    end
  end

  def test_tabs
    render_inline(Polaris::CardComponent.new) do |card|
      card.with_tabs do |tabs|
        tabs.with_tab(title: "Tab Title")
      end
    end

    assert_selector ".Polaris-LegacyCard > .Polaris-LegacyCard__Surface > .Polaris-LegacyTabs__Wrapper > ul.Polaris-LegacyTabs" do
      assert_selector "li.Polaris-LegacyTabs__TabContainer > button.Polaris-LegacyTabs__Tab", text: "Tab Title"
    end
  end

  def test_untitled_card_has_only_a_content_surface
    render_inline(Polaris::CardComponent.new) { "Content" }

    assert_no_selector ".Polaris-LegacyCard__Header"
    assert_selector ".Polaris-LegacyCard > .Polaris-LegacyCard__Surface > .Polaris-LegacyCard__Section", text: "Content"
  end

  def test_footer_actions_stay_inside_surface
    render_inline(Polaris::CardComponent.new(title: "Card")) do |card|
      card.with_primary_footer_action(url: "/save") { "Save" }
      "Content"
    end

    assert_selector ".Polaris-LegacyCard__Surface > .Polaris-LegacyCard__Footer a[href='/save']"
  end

  def test_footer_actions_default_to_left_alignment_with_primary_first
    render_inline(Polaris::CardComponent.new(title: "Card")) do |card|
      card.with_primary_footer_action { "Save" }
      card.with_secondary_footer_action { "Cancel" }
    end

    assert_selector ".Polaris-LegacyCard__Footer.Polaris-LegacyCard__LeftJustified" do
      assert_selector ".Polaris-ButtonGroup__Item:nth-child(1) .Polaris-Button--primary", text: "Save"
      assert_selector ".Polaris-ButtonGroup__Item:nth-child(2) .Polaris-Button", text: "Cancel"
    end
  end
end
