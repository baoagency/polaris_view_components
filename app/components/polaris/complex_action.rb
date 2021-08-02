module Polaris
  class ComplexAction
    attr_reader :content

    def initialize(
      content:,
      accessibility_label: '',
      destructive: false,
      disabled: false,
      external: false,
      id: '',
      loading: false,
      outline: false,
      submit: false,
      url: ''
    )
      @content = content
      @accessibility_label = accessibility_label
      @destructive = destructive
      @disabled = disabled
      @external = external
      @id = id
      @loading = loading
      @outline = outline
      @submit = submit
      @url = url
    end

    def to_h
      {
        content: @content,
        accessibility_label: @accessibility_label,
        destructive: @destructive,
        disabled: @disabled,
        external: @external,
        id: @id,
        loading: @loading,
        outline: @outline,
        submit: @submit,
        url: @url,
      }
    end
  end
end
