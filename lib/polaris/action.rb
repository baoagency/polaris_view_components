module Polaris
  class Action
    attr_reader :content

    def initialize(
      content:,
      url:,
      accessibility_label: '',
      external: false,
      id: '',
      data: {}
    )
      @content = content
      @accessibility_label = accessibility_label
      @external = external
      @id = id
      @url = url
      @data = data
    end

    def to_h
      {
        content: @content,
        accessibility_label: @accessibility_label,
        external: @external,
        id: @id,
        url: @url,
        data: @data,
      }
    end
  end
end
