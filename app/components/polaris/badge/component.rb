# frozen_string_literal: true

module Polaris
  module Badge
    class Component < Polaris::Component
      ALLOWED_PROGRESS = %w[incomplete partially_complete complete]
      ALLOWED_SIZES = %w[small medium]
      ALLOWED_STATUSES = %w[success info attention critical warning new]

      validates :progress, inclusion: { in: ALLOWED_PROGRESS, message: "%{value} is not a valid progress" }, allow_blank: true
      validates :size, inclusion: { in: ALLOWED_SIZES, message: "%{value} is not a valid size" }, allow_blank: true
      validates :status, inclusion: { in: ALLOWED_STATUSES, message: "%{value} is not a valid status" }, allow_blank: true

      attr_reader :progress, :size, :status

      def initialize(progress: '', size: ALLOWED_SIZES.last, status: '', **args)
        super

        @progress = progress
        @size = size
        @status = status
      end

      private

        def classes
          classes = ['Polaris-Badge']

          classes << 'Polaris-Badge--sizeSmall' if @size == 'small'
          classes << "Polaris-Badge--status#{@status.camelize}" if @status.present?
          classes << "Polaris-Badge--progress#{@progress.camelize}" if @progress.present?

          classes
        end
    end
  end
end
