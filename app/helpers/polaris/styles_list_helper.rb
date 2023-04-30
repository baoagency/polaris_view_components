# frozen_string_literal: true

module Polaris
  module StylesListHelper
    def styles_list(*args)
      list = []

      args.each do |style|
        case style
        when Hash
          style.each do |key, val|
            list << [key, val] if val
          end
        when Array
          list << styles_list(*style).presence
        end
      end

      list.compact.uniq.map { |k, v| "#{k}: #{v}" }.join(";")
    end
  end
end
