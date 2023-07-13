require "test_helper"

class LayoutComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_order
    render_inline(Polaris::LayoutComponent.new) do |layout|
      layout.with_section { "First" }
      layout.with_annotated_section(title: "Second") { "Second" }
      layout.with_section { "Third" }
    end

    assert_selector ".Polaris-Layout > *:nth-child(1)", text: "First"
    assert_selector ".Polaris-Layout > *:nth-child(2)", text: "Second"
    assert_selector ".Polaris-Layout > *:nth-child(3)", text: "Third"
  end

  def test_renders_nothing_if_no_slots_are_passed
    render_inline(Polaris::LayoutComponent.new)

    assert_content ""
  end

  def test_renders_default_layout_with_section
    render_inline(Polaris::LayoutComponent.new) do |layout|
      layout.with_section { "Default" }
    end

    assert_selector ".Polaris-Layout__Section"
  end

  def test_renders_multiple_sections
    render_inline(Polaris::LayoutComponent.new) do |layout|
      layout.with_section { "Default 1" }
      layout.with_section { "Default 2" }
      layout.with_section { "Default 3" }
    end

    assert_selector ".Polaris-Layout__Section", {count: 3}
  end

  def test_renders_mixed_sections
    render_inline(Polaris::LayoutComponent.new) do |layout|
      layout.with_section { "Default 1" }
      layout.with_annotated_section(title: "Annotated") { "Annotated 1" }
      layout.with_section { "Default 2" }
      layout.with_annotated_section(title: "Annotated") { "Annotated 2" }
      layout.with_section { "Default 3" }
    end

    assert_selector ".Polaris-Layout__Section", {count: 3}
    assert_selector ".Polaris-Layout__AnnotatedSection", {count: 2}
  end

  def test_renders_secondary_sections
    render_inline(Polaris::LayoutComponent.new) do |layout|
      layout.with_section(secondary: true) { "Default" }
    end

    assert_selector ".Polaris-Layout__Section--secondary"
  end

  def test_renders_full_width_sections
    render_inline(Polaris::LayoutComponent.new) do |layout|
      layout.with_section(full_width: true) { "Default" }
    end

    assert_selector ".Polaris-Layout__Section--fullWidth"
  end

  def test_renders_one_half_sections
    render_inline(Polaris::LayoutComponent.new) do |layout|
      layout.with_section(one_half: true) { "Default" }
    end

    assert_selector ".Polaris-Layout__Section--oneHalf"
  end

  def test_renders_one_third_sections
    render_inline(Polaris::LayoutComponent.new) do |layout|
      layout.with_section(one_third: true) { "Default" }
    end

    assert_selector ".Polaris-Layout__Section--oneThird"
  end

  def test_renders_with_annotated_sections
    render_inline(Polaris::LayoutComponent.new) do |layout|
      layout.with_annotated_section(title: "Test title") { "Default" }
    end

    assert_selector ".Polaris-Layout__AnnotatedSection", text: "Test title"

    render_inline(Polaris::LayoutComponent.new) do |layout|
      layout.with_annotated_section(title: "Test title", description: "Test description") { "Default" }
    end

    assert_selector ".Polaris-Layout__AnnotationDescription p", text: "Test description"
  end
end
