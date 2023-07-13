require "test_helper"

class SkeletonBodyTextComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_renders_default_skeleton
    render_inline(Polaris::SkeletonBodyTextComponent.new)

    assert_selector ".Polaris-SkeletonBodyText", count: 3
  end

  def test_renders_single_skeleton
    render_inline(Polaris::SkeletonBodyTextComponent.new(lines: 1))

    assert_selector ".Polaris-SkeletonBodyText", count: 1
  end
end
