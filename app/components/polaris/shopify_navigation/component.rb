module Polaris
  module ShopifyNavigation
    class Component < ApplicationComponent
      def initialize(links:, **args)
        super

        @links = links
      end

      def links
        @links.map do |link|
          {
            label: link[:label],
            href: link[:href],
            active: request.env['PATH_INFO'].include?(link[:href].split('?').first)
          }
        end
      end
    end
  end
end
