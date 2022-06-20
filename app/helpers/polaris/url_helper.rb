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

    def polaris_link_to(name = nil, options = nil, html_options = nil, &block)
      html_options, options, name = options, name, block if block
      options ||= {}

      html_options = convert_options_to_data_attributes(options, html_options)
      html_options[:classes] = html_options[:class]
      html_options.delete(:class)

      url = url_target(name, options)

      link = Polaris::LinkComponent.new(url: url, **html_options)
      link = link.with_content(name) unless block

      render(link, &block)
    end

    def polaris_mail_to(email_address, name = nil, html_options = {}, &block)
      html_options, name = name, nil if name.is_a?(Hash)
      html_options = (html_options || {}).stringify_keys
      html_options[:classes] = html_options[:class]
      html_options.delete(:class)

      extras = %w[cc bcc body subject reply_to].map! { |item|
        option = html_options.delete(item).presence || next
        "#{item.dasherize}=#{ERB::Util.url_encode(option)}"
      }.compact
      extras = extras.empty? ? "" : "?" + extras.join("&")

      encoded_email_address = ERB::Util.url_encode(email_address).gsub("%40", "@")
      url = "mailto:#{encoded_email_address}#{extras}"

      link = Polaris::LinkComponent.new(url: url, **html_options)
      link = link.with_content(name || email_address) unless block

      render(link, &block)
    end
  end
end
