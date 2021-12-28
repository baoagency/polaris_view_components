# frozen_string_literal: true

module Polaris
  module Dropzone
    # Lets users upload files by dragging and dropping the files into an area on a page, or activating a button.
    class FileUploadComponent < Polaris::NewComponent
      # @param [String] action_title
      # @param [String] action_hint
      # @param [Hash] system_arguments
      def initialize(action_title = "Add files", action_hint = "", **system_arguments)
        super

        @action_title = action_title
        @action_hint = action_hint

        @system_arguments = system_arguments
        @system_arguments[:tag] = :div
        @system_arguments[:classes] = class_names(
          @system_arguments[:classes],
          "Polaris-DropZone-FileUpload"
        )
      end
    end
  end
end
