module Polaris
  class PlaceholderComponent < Polaris::Component
    def initialize(height: "auto", width: "auto", label: nil)
      @label = label
      @system_arguments = {
        tag: :div,
        style: [
          "background-color: #7B47F1",
          "color: #fff",
          "width: #{width}",
          "height: #{height}",
          "display: flex",
          "align-items: center",
          "justify-content: center"
        ].join(";")
      }
    end

    def call
      if @label.present?
        render(Polaris::BaseComponent.new(**@system_arguments)) do
          render(Polaris::InlineComponent.new(align: :center)) do
            tag.div(style: "color: #fff;") do
              render(Polaris::TextComponent.new(as: :h2, variant: :body_md)) do
                @label
              end
            end
          end
        end
      else
        render(Polaris::BaseComponent.new(**@system_arguments)) { content }
      end
    end
  end
end
