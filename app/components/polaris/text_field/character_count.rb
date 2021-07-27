# frozen_string_literal: true
module Polaris
  module TextField
    class CharacterCount
      def initialize(text_field:, max_length: nil)
        @text_field = text_field
        @max_length = max_length
      end

      def label
        return "#{count} of #{@max_length} characters used" if max_length?

        "#{count} characters"
      end

      def text
        return "#{count}/#{@max_length}" if max_length?

        "#{count}"
      end

      def label_template
        if max_length?
          "{count} of {max_count} characters used"
        end

        "{count} characters"
      end

      def text_template
        return "{count}/{max_count}" if max_length?

        "{count}"
      end

      private

        def max_length?
          @max_length.present?
        end

        def normalized_value
          @text_field.value || ''
        end

        def count
          normalized_value.length
        end
    end
  end
end
