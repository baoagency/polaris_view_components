# frozen_string_literal: true

# TODO: Error overlay. See "Only accepts SVG"
# TODO: Dynamic sizing
# TODO: Variable height - Not sure if this is needed

module Polaris
  # Lets users upload files by dragging and dropping the files into an area on a page, or activating a button.
  class DropzoneComponent < Polaris::NewComponent
    include ActiveModel::Validations

    attr_reader :type, :label_action

    validates :type, inclusion: {in: %w[file image]}
    validates :label_action, type: Action, allow_nil: true

    def initialize(
      form: nil,
      attribute: nil,
      name: nil,

      label: nil,
      label_action: nil,
      label_hidden: true,
      id: "",
      accept: "",
      type: "file",
      active: false,
      error: false,
      outline: true,
      overlay: true,
      overlay_text: "Drop files to upload",
      error_overlay_text: "",
      allow_multiple: true,
      disabled: false,
      drop_on_page: false,
      open_file_dialog: true,
      variable_height: true,
      wrapper_arguments: {},
      input_arguments: {},
      file_upload_arguments: {},
      file_upload_button: "Add file",
      file_upload_help: "or drop files to upload",
      **system_arguments
    )
      @form = form
      @attribute = attribute
      @name = name

      @label = label
      @label_action = label_action
      @label_hidden = label_hidden
      @id = id
      @accept = accept
      @type = type
      @active = active
      @overlay = overlay
      @overlay_text = overlay_text
      @error_overlay_text = error_overlay_text
      @allow_multiple = allow_multiple
      @drop_on_page = drop_on_page
      @open_file_dialog = open_file_dialog
      @variable_height = variable_height
      @file_upload_button = file_upload_button
      @file_upload_help = file_upload_help

      @system_arguments = system_arguments
      @system_arguments[:tag] = :div

      @system_arguments[:data] ||= {}

      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-DropZone",
        "Polaris-DropZone--sizeExtraLarge", # TODO: Dynamic size class
        "Polaris-DropZone--hasOutline": outline,
        "Polaris-DropZone--isDisabled": disabled,
        "Polaris-DropZone--hasError": error
      )
      @system_arguments[:data] = {
        controller: "polaris-dropzone",
        action: "click->polaris-dropzone#onClick #{drop_actions}",
        'polaris-dropzone-accept-value': accept,
        'polaris-dropzone-allowMultiple-value': allow_multiple.to_s,
        'polaris-dropzone-disabled-value': disabled.to_s,
        'polaris-dropzone-focused-value': "false",
        'polaris-dropzone-drop-on-page-value': drop_on_page
      }
      @wrapper_arguments = wrapper_arguments
      @input_arguments = input_arguments
      @file_upload_arguments = file_upload_arguments
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
        type: "file",
        multiple: @allow_multiple,
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
