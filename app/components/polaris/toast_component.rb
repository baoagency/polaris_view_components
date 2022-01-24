class Polaris::ToastComponent < Polaris::Component
  renders_one :action, ->(**system_arguments) do
    Polaris::ButtonComponent.new(plain: true, monochrome: true, **system_arguments)
  end

  def initialize(
    hidden: false,
    duration: nil,
    error: false,
    **system_arguments
  )
    @hidden = hidden
    @duration = duration
    @error = error
    @system_arguments = system_arguments
  end

  def system_arguments
    @system_arguments.tap do |opts|
      opts[:tag] = "div"
      opts[:data] ||= {}
      prepend_option(opts[:data], :controller, "polaris-toast")
      opts[:data][:polaris_toast_hidden_value] = @hidden
      opts[:data][:polaris_toast_duration_value] = @duration
      opts[:data][:polaris_toast_has_action_value] = action.present?
      opts[:classes] = class_names(
        opts[:classes],
        "Polaris-Frame-ToastManager__ToastWrapper",
        "Polaris-Frame-ToastManager--toastWrapperEnterDone": !@hidden
      )
    end
  end

  def toast_classes
    class_names(
      "Polaris-Frame-Toast",
      "Polaris-Frame-Toast--error": @error
    )
  end
end
