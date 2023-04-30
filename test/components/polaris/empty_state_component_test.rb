require "test_helper"

class EmptyStateComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_empty_state
    render_inline(Polaris::EmptyStateComponent.new(
      heading: "Title",
      image: "/image.png"
    )) do |state|
      state.with_primary_action { "Primary Action" }
      state.with_secondary_action { "Secondary Action" }
      "Content"
    end

    assert_text "Title"
    assert_text "Content"
    assert_selector ".Polaris-Button--primary", text: "Primary Action"
    assert_selector ".Polaris-Button", text: "Secondary Action"
    assert_selector "img[src='/image.png']"
  end

  def test_empty_state_footer
    render_inline(Polaris::EmptyStateComponent.new(
      heading: "Title",
      image: "/image.png"
    )) do |state|
      state.with_footer { "Footer Content" }
    end

    assert_text "Footer Content"
  end

  def test_unsectioned_content
    render_inline(Polaris::EmptyStateComponent.new(
      heading: "Title",
      image: "/image.png"
    )) do |state|
      state.with_unsectioned_content do
        tag.div id: "unsectioned"
      end
    end

    assert_selector "#unsectioned"
  end
end
