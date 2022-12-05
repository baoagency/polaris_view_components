# frozen_string_literal: true

class DropzoneComponentPreview < ViewComponent::Preview
  # Use to allow merchants to upload files. They can drag and drop files into the dashed area, or upload traditionally by clicking the “Add file” button or anywhere inside the dashed area.
  def with_file_upload
  end

  # Use to pair with a label for better accessibility.
  def with_a_label
  end

  # Use for cases that accept image file formats.
  def with_image_upload
  end

  # Use to accept single files.
  def with_single_file_upload
  end

  # Use to accept files for upload when dropped anywhere on the page.
  def with_drop_on_page
  end

  # Use to accept only SVG files.
  def accepts_only_svg_files
  end

  # Use to trigger the file dialog from an action somewhere else on the page.
  def with_custom_file_dialog_trigger
  end

  def with_custom_file_button
  end

  def without_preview
  end

  def medium_sized
  end

  def small_sized
  end
end
