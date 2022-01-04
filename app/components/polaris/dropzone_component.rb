# frozen_string_literal: true

module Polaris
  # Lets users upload files by dragging and dropping the files into an area on a page, or activating a button.
  class DropzoneComponent < Polaris::NewComponent
    include ActiveModel::Validations

    SIZE_DEFAULT = :extra_large
    SIZE_MAPPINGS = {
      small: "Polaris-DropZone--sizeSmall",
      medium: "Polaris-DropZone--sizeMedium",
      large: "Polaris-DropZone--sizeLarge",
      extra_large: "Polaris-DropZone--sizeExtraLarge"
    }
    SIZE_OPTIONS = SIZE_MAPPINGS.keys

    attr_reader :label_action

    validates :label_action, type: Action, allow_nil: true

    def initialize(
      form: nil,
      attribute: nil,
      name: nil,
      accept: "",
      multiple: true,
      size: SIZE_DEFAULT,
      drop_on_page: false,
      preview: true,
      outline: true,
      overlay_text: "Drop files to upload",
      error_overlay_text: "This file type isn't accepted",
      label: nil,
      label_hidden: true,
      label_action: nil,
      disabled: false,
      error: false,
      file_upload_button: nil,
      file_upload_help: "or drop files to upload",
      file_upload_arguments: {},
      wrapper_arguments: {},
      input_arguments: {},
      **system_arguments
    )
      @form = form
      @attribute = attribute
      @name = name
      @accept = accept
      @multiple = multiple
      @size = size
      @drop_on_page = drop_on_page
      @preview = preview
      @outline = outline
      @overlay_text = overlay_text
      @error_overlay_text = error_overlay_text
      @label = label
      @label_hidden = label_hidden
      @label_action = label_action
      @disabled = disabled
      @error = error
      @file_upload_button = file_upload_button
      @file_upload_button ||= "Add #{multiple ? "files" : "file"}"
      @file_upload_help = file_upload_help
      @file_upload_arguments = file_upload_arguments
      @wrapper_arguments = wrapper_arguments
      @input_arguments = input_arguments
      @system_arguments = system_arguments
    end

    def system_arguments
      @system_arguments.tap do |opts|
        opts[:tag] = "div"
        opts[:data] = {
          controller: "polaris-dropzone",
          action: "click->polaris-dropzone#onClick #{drop_actions}",
          polaris_dropzone_accept_value: @accept,
          polaris_dropzone_allow_multiple_value: @multiple.to_s,
          polaris_dropzone_disabled_value: @disabled.to_s,
          polaris_dropzone_focused_value: "false",
          polaris_dropzone_drop_on_page_value: @drop_on_page,
          polaris_dropzone_render_preview_value: @preview
        }
        opts[:classes] = class_names(
          opts[:classes],
          "Polaris-DropZone",
          SIZE_MAPPINGS[fetch_or_fallback(SIZE_OPTIONS, @size, SIZE_DEFAULT)],
          "Polaris-DropZone--hasOutline": @outline,
          "Polaris-DropZone--isDisabled": @disabled,
          "Polaris-DropZone--hasError": @error
        )
      end
    end

    def wrapper_arguments
      {
        form: @form,
        attribute: @attribute,
        name: @name,
        label: @label,
        label_hidden: @label_hidden,
        label_action: @label_action,
        error: @error
      }.deep_merge(@wrapper_arguments)
    end

    def input_arguments
      {
        accept: @accept,
        disabled: @disabled,
        multiple: @multiple,
        data: {
          action: "focus->polaris-dropzone#onFocus blur->polaris-dropzone#onBlur change->polaris-dropzone#onChange",
          'polaris-dropzone-target': "input"
        }
      }.deep_merge(@input_arguments)
    end

    def file_upload_arguments
      {
        tag: "div",
        classes: class_names(
          "Polaris-DropZone-FileUpload"
        ),
        data: {
          'polaris-dropzone-target': "fileUpload"
        }
      }.deep_merge(@file_upload_arguments.except(:language))
    end

    def drop_actions
      event_scope = @drop_on_page ? "@document" : ""

      [
        "drop#{event_scope}->polaris-dropzone#onDrop",
        "dragover#{event_scope}->polaris-dropzone#onDragOver",
        "dragenter#{event_scope}->polaris-dropzone#onDragEnter",
        "dragleave#{event_scope}->polaris-dropzone#onDragLeave"
      ].join(" ")
    end
  end
end
