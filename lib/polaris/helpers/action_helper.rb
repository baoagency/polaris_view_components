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
        case action
          when Hash
            action = action(**action)
        end

        render Polaris::ButtonComponent.new(**action.to_h.except(:content)) do
          action.content
        end
      end

      def render_plain_action(action)
        case action
          when Hash
            action = action(**action)
        end

        render Polaris::ButtonComponent.new(**action.to_h.except(:content), plain: true) do
          action.content
        end
      end

      def render_complex_action_button(complex_action)
        case complex_action
          when Hash
            complex_action = complex_action(**complex_action)
        end

        render Polaris::ButtonComponent.new(**complex_action.to_h.except(:content)) do
          complex_action.content
        end
      end

      def render_primary_complex_action_button(complex_action)
        case complex_action
          when Hash
            complex_action = complex_action(**complex_action)
        end

        render Polaris::ButtonComponent.new(**complex_action.to_h.except(:content), primary: true) do
          complex_action.content
        end
      end

      def render_plain_complex_action_button(complex_aciton)
        case complex_aciton
          when Hash
            complex_aciton = complex_action(**complex_aciton)
        end

        render Polaris::ButtonComponent.new(**complex_aciton.to_h.except(:content), plain: true) do
          complex_aciton.content
        end
      end
    end
  end
end
