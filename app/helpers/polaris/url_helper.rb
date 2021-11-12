module Polaris
  module UrlHelper
    def polaris_button_to(name = nil, options = nil, html_options = nil, &block)
      html_options, options = options, name if block
      options ||= {}
      html_options ||= {}
      html_options[:classes] = html_options[:class]
      html_options.delete(:class)

      button = Polaris::HeadlessButton.new(submit: true, **html_options)
      button = button.with_content(name) unless block
      content = render(button, &block)

      button_to(options, button.html_options) do
        content
      end
    end
  end
end
