module Polaris
  module ConditionalHelper
    def conditional_wrapping_element(tag, options = {}, &block)
      if options.delete(:show)
        content_tag(tag, capture(&block), options)
      else
        capture(&block)
      end
    end
  end
end
