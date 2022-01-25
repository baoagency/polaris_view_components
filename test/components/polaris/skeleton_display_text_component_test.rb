require "test_helper"

class SkeletonDisplayTextComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_renders_default_skeleton
    render_inline(Polaris::SkeletonDisplayTextComponent.new)

    assert_selector ".Polaris-SkeletonDisplayText__DisplayText.Polaris-SkeletonDisplayText--sizeMedium"
  end

  def test_renders_large_skeleton
    render_inline(Polaris::SkeletonDisplayTextComponent.new(size: :large))

    assert_selector ".Polaris-SkeletonDisplayText--sizeLarge"
  end
end
