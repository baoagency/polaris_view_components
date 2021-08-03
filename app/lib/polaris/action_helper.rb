module Polaris
  module ActionHelper
    def render_plain_action(action)
      case action
        when Hash
          action = action(**action)
      end

      render Polaris::ButtonComponent.new(**action.to_h.except(:content), plain: true) do
        action.content
      end
    end
  end
end
