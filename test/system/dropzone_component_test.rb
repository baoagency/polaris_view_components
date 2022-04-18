require "application_system_test_case"

class DropzoneComponentSystemTest < ApplicationSystemTestCase
  def test_file_upload
    with_preview("forms/dropzone_component/with_file_upload")

    find(".Polaris-DropZone").drop(fixture_file("file.txt"), fixture_file("image.png"))
    assert_selector ".Polaris-DropZone__Preview > .Polaris-Stack > .Polaris-Stack__Item", count: 2
    within ".Polaris-DropZone__Preview > .Polaris-Stack" do
      assert_selector ".Polaris-Stack__Item:nth-child(1)" do
        assert_text "file.txt"
        assert_text "10 Bytes"
      end
      assert_selector ".Polaris-Stack__Item:nth-child(2)" do
        assert_text "image.png"
        assert_text "11.37 KB"
      end
    end
  end

  def test_image_upload
    with_preview("forms/dropzone_component/with_image_upload")

    find(".Polaris-DropZone").drop(fixture_file("file.txt"))
    assert_selector ".Polaris-DropZone__Overlay", text: "This file type isn't accepted"

    with_preview("forms/dropzone_component/with_image_upload")

    find(".Polaris-DropZone").drop(fixture_file("image.png"))
    within ".Polaris-DropZone__Preview" do
      assert_text "image.png"
      assert_text "11.37 KB"
    end
  end

  def test_single_file_upload
    with_preview("forms/dropzone_component/with_single_file_upload")

    find(".Polaris-DropZone").drop(fixture_file("file.txt"), fixture_file("image.png"))
    assert_selector ".Polaris-DropZone__Preview > .Polaris-Stack > .Polaris-Stack__Item", count: 1
    within ".Polaris-DropZone__Preview" do
      assert_text "file.txt"
      assert_text "10 Bytes"
    end
  end

  def test_drop_on_page
    with_preview("forms/dropzone_component/with_drop_on_page")

    first(".Polaris-Page").drop(fixture_file("file.txt"))
    within ".Polaris-DropZone__Preview" do
      assert_text "file.txt"
      assert_text "10 Bytes"
    end
  end

  def test_accepts_only_svg
    with_preview("forms/dropzone_component/accepts_only_svg_files")

    find(".Polaris-DropZone").drop(fixture_file("file.txt"))
    assert_selector ".Polaris-DropZone__Overlay", text: "File type must be .svg"

    with_preview("forms/dropzone_component/with_image_upload")

    find(".Polaris-DropZone").drop(fixture_file("image.svg"))
    within ".Polaris-DropZone__Preview" do
      assert_text "image.svg"
      assert_text "5.63 KB"
    end
  end

  def test_small_dropzone
    with_preview("forms/dropzone_component/small_sized")

    find(".Polaris-DropZone").drop(fixture_file("image.png"))
    within ".Polaris-DropZone__Preview" do
      assert_no_text "image.png"
      assert_no_text "11.37 KB"
      assert_selector ".Polaris-Thumbnail > img[alt='image.png']"
    end
  end

  def fixture_file(name)
    Rails.root.join("../test/fixtures/#{name}")
  end
end
