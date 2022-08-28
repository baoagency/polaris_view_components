require "test_helper"

class ActionListComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_dropzone
    render_inline(Polaris::DropzoneComponent.new(name: :file_input))

    assert_selector ".Polaris-DropZone.Polaris-DropZone--sizeExtraLarge" do
      assert_selector ".Polaris-DropZone__Container" do
        assert_selector ".Polaris-DropZone-FileUpload__Button", text: "Add files"
        assert_text "or drop files to upload"
      end
      assert_selector "input[type=file][multiple][name=file_input]"
    end
  end

  def test_dropzone_preview_template
    rendered = render_inline(Polaris::DropzoneComponent.new(name: :file_input))
    template = rendered.at_css("template[data-polaris-dropzone-target=previewTemplate] > *").to_html
    template_page = Capybara::Node::Simple.new(template)

    assert_selector template_page, ".Polaris-DropZone__Preview", visible: :all
  end

  def test_dropzone_with_label
    render_inline(Polaris::DropzoneComponent.new(label: "Dropzone Label", label_hidden: false))

    assert_selector ".Polaris-Labelled__LabelWrapper" do
      assert_selector ".Polaris-Label", text: "Dropzone Label"
      assert_selector ".Polaris-DropZone"
    end
  end

  def test_image_only_dropzone
    render_inline(Polaris::DropzoneComponent.new(accept: "image/*"))

    assert_selector "input[accept='image/*']"
  end

  def test_single_file_dropzone
    render_inline(Polaris::DropzoneComponent.new(multiple: false))

    assert_selector "input[type=file]"
    assert_no_selector "input[type=file][multiple]"
  end

  def test_error_overlay_text
    render_inline(Polaris::DropzoneComponent.new(error_overlay_text: "Error overlay text"))

    assert_selector ".Polaris-DropZone__Overlay", text: "Error overlay text"
  end

  def test_dropzone_without_preview
    render_inline(Polaris::DropzoneComponent.new(preview: false))

    assert_selector ".Polaris-DropZone[data-polaris-dropzone-render-preview-value='false']"
  end

  def test_medium_dropzone
    render_inline(Polaris::DropzoneComponent.new(size: :medium))

    assert_selector ".Polaris-DropZone.Polaris-DropZone--sizeMedium"
  end

  def test_small_dropzone
    render_inline(Polaris::DropzoneComponent.new(size: :small))

    assert_selector ".Polaris-DropZone.Polaris-DropZone--sizeSmall"
  end
end
