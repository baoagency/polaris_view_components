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

    assert_selector ".Polaris-EmptyState > .Polaris-EmptyState__Section" do
      assert_selector ".Polaris-EmptyState__DetailsContainer > .Polaris-EmptyState__Details" do
        assert_selector ".Polaris-TextContainer" do
          assert_selector ".Polaris-DisplayText", text: "Title"
          assert_selector ".Polaris-EmptyState__Content", text: "Content"
        end
        assert_selector ".Polaris-EmptyState__Actions > .Polaris-LegacyStack" do
          assert_selector ".Polaris-LegacyStack__Item", count: 2
          assert_selector ".Polaris-LegacyStack__Item:nth-child(1)" do
            assert_selector ".Polaris-Button--primary", text: "Primary Action"
          end
          assert_selector ".Polaris-LegacyStack__Item:nth-child(2)" do
            assert_selector ".Polaris-Button", text: "Secondary Action"
          end
        end
      end
      assert_selector ".Polaris-EmptyState__ImageContainer" do
        assert_selector "img.Polaris-EmptyState__Image[src='/image.png']"
      end
    end
  end

  def test_empty_state_footer
    render_inline(Polaris::EmptyStateComponent.new(
      heading: "Title",
      image: "/image.png"
    )) do |state|
      state.with_footer { "Footer Content" }
    end

    assert_selector ".Polaris-EmptyState__Details > .Polaris-EmptyState__FooterContent" do
      assert_selector ".Polaris-TextContainer", text: "Footer Content"
    end
  end

  def test_full_width_empty_state
    render_inline(Polaris::EmptyStateComponent.new(
      heading: "Title",
      image: "/image.png",
      full_width: true
    ))

    assert_selector ".Polaris-EmptyState--fullWidth"
  end

  def test_empty_state_without_actions
    render_inline(Polaris::EmptyStateComponent.new(
      heading: "Title",
      image: "/image.png"
    ))

    assert_no_selector ".Polaris-EmptyState__Details > .Polaris-EmptyState__Actions"
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

    assert_selector ".Polaris-EmptyState > #unsectioned"
  end
end
