require "test_helper"

class BadgeComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_renders_default_badge
    render_inline(Polaris::BadgeComponent.new) { "Default" }

    assert_selector "span.Polaris-Badge", text: "Default"
  end

  def test_renders_incomplete_badge
    render_inline(Polaris::BadgeComponent.new(progress: :incomplete)) { "Text" }

    assert_selector "span.Polaris-Badge--progressIncomplete"
  end

  def test_renders_small_badge
    render_inline(Polaris::BadgeComponent.new(size: :small)) { "Text" }

    assert_selector "span.Polaris-Badge--sizeSmall"
  end

  def test_renders_warning_badge
    render_inline(Polaris::BadgeComponent.new(status: :warning)) { "Text" }

    assert_selector "span.Polaris-Badge--statusWarning"
  end
end
