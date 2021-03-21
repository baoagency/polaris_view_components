# frozen_string_literal: true

module Polaris
  module Dropzone
    class Component < Polaris::Component
      include ActionHelper

      ALLOWED_TYPES = %w[file image]

      validates :type, inclusion: { in: ALLOWED_TYPES, message: "%{value} is not a valid type" }
      validates :label_action, type: Action, allow_nil: true

      # TODO
      # Options missing:
      # - open_file_dialog
      # - overlay
      # - overlay_text
      # - Size CSS Class
      # - Doesn't take into account an initial load with files

      attr_reader :label_action, :type

      def initialize(
        form:,
        attr:,
        accept: "",
        active: false,
        allow_multiple: true,
        disabled: false,
        drop_on_page: false,
        error: false,
        error_overlay_text: "",
        id: "",
        label: "",
        label_action: nil,
        label_hidden: false,
        overlay_text: "Drop file to upload",
        outline: true,
        type: "file",
        **args
      )
        super

        @form = form
        @attr = attr
        @accept = accept
        @active = active
        @allow_multiple = allow_multiple
        @disabled = disabled
        @drop_on_page = drop_on_page
        @error = error
        @error_overlay_text = error_overlay_text
        @id = id
        @label = label
        @label_action = label_action
        @label_hidden = label_hidden
        @overlay_text = overlay_text
        @outline = outline
        @type = type
      end

      def labelled_attrs
        {
          form: @form,
          attr: @attr,
          error: @error,
          label: @label,
          label_hidden: @label_hidden,
          index: @index,
          action: @label_action
        }
      end

      def input_attrs
        {
          accept: @accept,
          disabled: @disabled,
          type: "file",
          multiple: @allow_multiple,
          data: {
            action: "focus->polaris--dropzone#onFocus blur->polaris--dropzone#onBlur change->polaris--dropzone#onChange",
            'polaris--dropzone-target': 'input',
          }
        }
      end

      private

        def additional_aria
          {
            disabled: @disabled.to_s,
          }
        end

        def additional_data
          {
            controller: "polaris--dropzone",
            action: "click->polaris--dropzone#onClick #{drop_actions}",
            'polaris--dropzone-accept-value': @accept,
            'polaris--dropzone-allowMultiple-value': @allow_multiple.to_s,
            'polaris--dropzone-disabled-value': @disabled.to_s,
            'polaris--dropzone-focused-value': 'false',
            'polaris--dropzone-drop-on-page-value': 'false',
          }
        end

        def drop_actions
          event_scope = @drop_on_page ? "@document" : ""

          [
            "drop#{event_scope}->polaris--dropzone#onDrop",
            "dragover#{event_scope}->polaris--dropzone#onDragOver",
            "dragenter#{event_scope}->polaris--dropzone#onDragEnter",
            "dragleave#{event_scope}->polaris--dropzone#onDragLeave"
          ].join(" ")
        end

        def classes
          classes = %w[Polaris-DropZone Polaris-DropZone--sizeExtraLarge]

          classes << "Polaris-DropZone--isDisabled" if @disabled
          classes << "Polaris-DropZone--isDisabled" if @disabled
          classes << "Polaris-DropZone--hasError" if @error.present?
          classes << "Polaris-DropZone--hasOutline" if @outline

          classes
        end
    end
  end
end
