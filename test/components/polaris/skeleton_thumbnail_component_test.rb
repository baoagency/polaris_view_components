require "test_helper"

class SkeletonBodyTextComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_renders_default_thumbnail
    render_inline(Polaris::SkeletonThumbnailComponent.new)

    assert_selector ".Polaris-SkeletonThumbnail.Polaris-SkeletonThumbnail--sizeMedium"
  end

  def test_renders_large_thumbnail
    render_inline(Polaris::SkeletonThumbnailComponent.new(size: :large))

    assert_selector ".Polaris-SkeletonThumbnail--sizeLarge"
  end
end
