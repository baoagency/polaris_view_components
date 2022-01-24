class Polaris::Frame::SaveBarComponent < Polaris::Component
  renders_one :save_action, ->(**system_arguments) do
    Polaris::ButtonComponent.new(primary: true, **system_arguments)
  end
  renders_one :discard_action, Polaris::ButtonComponent

  def initialize(message:, flush: false, full_width: false, logo: nil, **system_arguments)
    @message = message
    @flush = flush
    @full_width = full_width
    @logo = logo.is_a?(Hash) ? Polaris::Logo.new(**logo) : logo
    @system_arguments = system_arguments
  end

  def system_arguments
    @system_arguments.tap do |opts|
      opts[:tag] = "div"
      opts[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Frame-ContextualSaveBar"
      )
    end
  end

  def content_classes
    class_names(
      "Polaris-Frame-ContextualSaveBar__Contents",
      "Polaris-Frame-ContextualSaveBar--fullWidth": @full_width
    )
  end
end
