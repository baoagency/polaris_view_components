require "application_system_test_case"

class DropzoneComponentSystemTest < ApplicationSystemTestCase
  def test_file_upload
    with_preview("dropzone_component/with_file_upload")

    find(".Polaris-DropZone").drop(fixture_file("file.txt"), fixture_file("image.png"))
    assert_selector ".Polaris-DropZone__Preview > .Polaris-LegacyStack > .Polaris-LegacyStack__Item", count: 2
    within ".Polaris-DropZone__Preview > .Polaris-LegacyStack" do
      assert_selector ".Polaris-LegacyStack__Item:nth-child(1)" do
        assert_text "file.txt"
        assert_text "10 Bytes"
      end
      assert_selector ".Polaris-LegacyStack__Item:nth-child(2)" do
        assert_text "image.png"
        assert_text "11.37 KB"
      end
    end
  end

  def test_submiting_file
    with_preview("form_builder_component/dropzone")

    within first("form") do
      find(".Polaris-DropZone").drop(fixture_file("file.txt"))
      assert_selector ".Polaris-DropZone__Preview > .Polaris-LegacyStack > .Polaris-LegacyStack__Item", count: 1

      click_on "Submit"
    end

    assert_text "File: file.txt"
  end

  def test_image_upload
    with_preview("dropzone_component/with_image_upload")

    find(".Polaris-DropZone").drop(fixture_file("file.txt"))
    assert_selector ".Polaris-DropZone__Overlay", text: "This file type isn't accepted"

    with_preview("dropzone_component/with_image_upload")

    find(".Polaris-DropZone").drop(fixture_file("image.png"))
    within ".Polaris-DropZone__Preview" do
      assert_text "image.png"
      assert_text "11.37 KB"
    end
  end

  def test_single_file_upload
    with_preview("dropzone_component/with_single_file_upload")

    find(".Polaris-DropZone").drop(fixture_file("file.txt"), fixture_file("image.png"))
    assert_selector ".Polaris-DropZone__Preview > .Polaris-LegacyStack > .Polaris-LegacyStack__Item", count: 1
    within ".Polaris-DropZone__Preview" do
      assert_text "file.txt"
      assert_text "10 Bytes"
    end
  end

  def test_drop_on_page
    with_preview("dropzone_component/with_drop_on_page")

    first(".Polaris-Page").drop(fixture_file("file.txt"))
    within ".Polaris-DropZone__Preview" do
      assert_text "file.txt"
      assert_text "10 Bytes"
    end
  end

  def test_accepts_only_svg
    with_preview("dropzone_component/accepts_only_svg_files")

    find(".Polaris-DropZone").drop(fixture_file("file.txt"))
    assert_selector ".Polaris-DropZone__Overlay", text: "File type must be .svg"

    with_preview("dropzone_component/with_image_upload")

    find(".Polaris-DropZone").drop(fixture_file("image.svg"))
    within ".Polaris-DropZone__Preview" do
      assert_text "image.svg"
      assert_text "5.63 KB"
    end
  end

  def test_small_dropzone
    with_preview("dropzone_component/small_sized")

    find(".Polaris-DropZone").drop(fixture_file("image.png"))
    within ".Polaris-DropZone__Preview" do
      assert_no_text "image.png"
      assert_no_text "11.37 KB"
      assert_selector ".Polaris-Thumbnail > img[alt='image.png']"
    end
  end

  def test_multiple_direct_uploads
    with_preview("form_builder_component/dropzone")

    within all("form")[1] do
      first_dropzone = all(".Polaris-DropZone")[0]
      second_dropzone = all(".Polaris-DropZone")[1]

      first_dropzone.drop(fixture_file("file.txt"))
      within first_dropzone do
        assert_selector ".Polaris-DropZone__Preview > .Polaris-Thumbnail", count: 1
      end
      second_dropzone.drop(fixture_file("image.png"))
      within second_dropzone do
        assert_selector ".Polaris-DropZone__Preview > .Polaris-Thumbnail", count: 1
      end

      click_on "Submit"
    end

    assert_text "Attachments (2)"
  end

  def test_reselect_file
    with_preview("dropzone_component/with_file_upload")

    find(".Polaris-DropZone").drop(fixture_file("file.txt"), fixture_file("image.png"))
    assert_selector ".Polaris-DropZone__Preview > .Polaris-LegacyStack > .Polaris-LegacyStack__Item", count: 2
    within ".Polaris-DropZone__Preview > .Polaris-LegacyStack" do
      assert_selector ".Polaris-LegacyStack__Item:nth-child(1)" do
        assert_text "file.txt"
        assert_text "10 Bytes"
      end
      assert_selector ".Polaris-LegacyStack__Item:nth-child(2)" do
        assert_text "image.png"
        assert_text "11.37 KB"
      end
    end

    page.attach_file(fixture_file("image.png")) do
      page.find(".Polaris-DropZone").click
    end

    assert_selector ".Polaris-DropZone__Preview > .Polaris-LegacyStack > .Polaris-LegacyStack__Item", count: 1
    within ".Polaris-DropZone__Preview > .Polaris-LegacyStack" do
      assert_selector ".Polaris-LegacyStack__Item:nth-child(1)" do
        assert_text "image.png"
        assert_text "11.37 KB"
      end
    end
  end

  def fixture_file(name)
    Rails.root.join("../test/fixtures/#{name}")
  end
end
