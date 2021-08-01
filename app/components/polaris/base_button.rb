# frozen_string_literal: true

module Polaris
  class BaseButton < Polaris::NewComponent
    def initialize(
      url: nil,
      external: false,
      disabled: false,
      loading: false,
      **system_arguments
    )
      @system_arguments = system_arguments
      @system_arguments[:tag] = url.present? ? 'a' : 'button'
      if loading
        @system_arguments[:disabled] = true
      end
      if url.present?
        @system_arguments.delete(:type)
        @system_arguments[:href] = url
        @system_arguments[:target] = "_blank" if external
      end
      if disabled
        @system_arguments[:disabled] = disabled
      end
    end

    def call
      render(BaseComponent.new(**@system_arguments)) { content }
    end
  end
end
