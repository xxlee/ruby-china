# 基本 Model，加入一些通用功能
module Mongoid
  # BaseModel
  module BaseModel
    extend ActiveSupport::Concern

    included do
      scope :recent, -> { desc(:_id) }
      scope :exclude_ids, ->(ids) { where(:_id.nin => ids.map(&:to_i)) }
      scope :by_week, -> { where(:created_at.gte => 7.days.ago.utc) }

      delegate :url_helpers, to: 'Rails.application.routes'
    end

    module ClassMethods
      # like ActiveRecord find_by_id
      def find_by_id(id)
        if id.is_a?(Integer) || id.is_a?(String)
          where(_id: id.to_i).first
        end
      end

      def find_in_batches(opts = {})
        batch_size = opts[:batch_size] || 1000
        start = opts.delete(:start).to_i || 0
        objects = limit(batch_size).skip(start)
        while objects.any?
          yield objects
          start += batch_size
          # Rails.logger.debug("processed #{start} records in #{Time.new - t} seconds") if Rails.logger.debug?
          break if objects.size < batch_size
          objects = limit(batch_size).skip(start)
        end
      end
    end
  end
end
