# frozen_string_literal: true

module Polaris
  # Lets users upload files by dragging and dropping the files into an area on a page, or activating a button.
  class DropzoneComponent < Polaris::Component
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
      direct_upload: false,
      multiple: true,
      size: SIZE_DEFAULT,
      drop_on_page: false,
      preview: true,
      outline: true,
      overlay_text: "Drop files to upload",
      error_overlay_text: "This file type isn't accepted",
      upload_error_text: "File upload failed",
      label: nil,
      label_hidden: true,
      label_action: nil,
      disabled: false,
      error: false,
      remove_previews_after_upload: true,
      file_upload_button: nil,
      file_upload_help: "or drop files to upload",
      file_upload_arguments: {},
      wrapper_arguments: {},
      input_options: {},
      **system_arguments
    )
      @form = form
      @attribute = attribute
      @name = name
      @accept = accept
      @direct_upload = direct_upload
      @multiple = multiple
      @size = size
      @drop_on_page = drop_on_page
      @preview = preview
      @outline = outline
      @overlay_text = overlay_text
      @error_overlay_text = error_overlay_text
      @upload_error_text = upload_error_text
      @label = label
      @label_hidden = label_hidden
      @label_action = label_action
      @disabled = disabled
      @error = error
      @remove_previews_after_upload = remove_previews_after_upload
      @file_upload_button = file_upload_button
      @file_upload_button ||= "Add #{multiple ? "files" : "file"}"
      @file_upload_help = file_upload_help
      @file_upload_arguments = file_upload_arguments
      @wrapper_arguments = wrapper_arguments
      @input_options = input_options
      @system_arguments = system_arguments
    end

    def system_arguments
      {
        tag: "div",
        data: {
          polaris_dropzone_accept_value: @accept,
          polaris_dropzone_allow_multiple_value: @multiple.to_s,
          polaris_dropzone_disabled_value: @disabled.to_s,
          polaris_dropzone_disabled_class: "Polaris-DropZone--isDisabled",
          polaris_dropzone_focused_value: "false",
          polaris_dropzone_drop_on_page_value: @drop_on_page,
          polaris_dropzone_render_preview_value: @preview,
          polaris_dropzone_size_value: @size,
          polaris_dropzone_remove_previews_after_upload_value: @remove_previews_after_upload
        }
      }.deep_merge(@system_arguments).tap do |opts|
        prepend_option(opts[:data], :controller, "polaris-dropzone")
        prepend_option(opts[:data], :action, "click->polaris-dropzone#onClick #{drop_actions}")
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

    def input_options
      {
        accept: @accept,
        direct_upload: @direct_upload,
        disabled: @disabled,
        multiple: @multiple,
        data: {polaris_dropzone_target: "input"}
      }.deep_merge(@input_options).tap do |opts|
        prepend_option(opts[:data], :action, "focus->polaris-dropzone#onFocus blur->polaris-dropzone#onBlur change->polaris-dropzone#onChange")
      end
    end

    def file_upload_arguments
      {
        tag: "div",
        classes: class_names(
          "Polaris-DropZone-FileUpload",
          "Polaris-DropZone-FileUpload--large": @size.in?(%i[large extra_large]),
          "Polaris-DropZone-FileUpload--small": @size == :small
        ),
        data: {
          polaris_dropzone_target: "fileUpload"
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
