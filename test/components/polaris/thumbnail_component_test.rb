require "test_helper"

class ThumbnailComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_thumbnail
    render_inline(Polaris::ThumbnailComponent.new(source: "/image.png"))

    assert_selector "span.Polaris-Thumbnail.Polaris-Thumbnail--sizeMedium" do
      assert_selector "img[src='/image.png']"
    end
  end

  def test_small_thumbnail
    render_inline(Polaris::ThumbnailComponent.new(source: "/image.png", size: :small))

    assert_selector "span.Polaris-Thumbnail.Polaris-Thumbnail--sizeSmall"
  end

  def test_large_thumbnail
    render_inline(Polaris::ThumbnailComponent.new(source: "/image.png", size: :large))

    assert_selector "span.Polaris-Thumbnail.Polaris-Thumbnail--sizeLarge"
  end

  def test_thumbnail_with_icon
    render_inline(Polaris::ThumbnailComponent.new) do |thumbnail|
      thumbnail.with_icon(name: "NoteIcon")
    end

    assert_selector ".Polaris-Thumbnail > .Polaris-Icon"
  end
end
