module Polaris
  class PlaceholderComponent < Polaris::Component
    def initialize(height: 'auto', width: 'auto')
      @system_arguments = {
        tag: :div,
        style: "background-color: #7B47F1; color: #fff; width: #{width}; height: #{height}; display: flex; align-items: center; justify-content: center;"
      }
    end

    def call
      render(Polaris::BaseComponent.new(**@system_arguments)) { content }
    end
  end
end
