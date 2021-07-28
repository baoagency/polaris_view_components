module Polaris
  module Helpers
    module ActionHelper
      def action(**args)
        Polaris::Action.new(**args)
      end

      def complex_action(**args)
        Polaris::ComplexAction.new(**args)
      end

      def render_action(action)
        render Polaris::Button::Component.new(**action.to_h.except(:content)) do
          action.content
        end
      end

      def render_plain_action(action)
        render Polaris::Button::Component.new(**action.to_h.except(:content), plain: true) do
          action.content
        end
      end

      def render_complex_action_button(complex_action)
        render Polaris::Button::Component.new(**complex_action.to_h.except(:content)) do
          complex_action.content
        end
      end

      def render_primary_complex_action_button(complex_action)
        render Polaris::Button::Component.new(**complex_action.to_h.except(:content), primary: true) do
          complex_action.content
        end
      end

      def render_plain_complex_action_button(complex_action)
        render Polaris::Button::Component.new(**complex_action.to_h.except(:content), plain: true) do
          complex_action.content
        end
      end
    end
  end
end
