module LegacyIdHandler
  extend ActiveSupport::Concern
  included do
    before_create :set_uuid
  end

  def save(*args, &block)
    if new_record?
      retries = 0
      loop do
        begin
          return super(*args, &block)
        rescue ActiveRecord::RecordNotUnique => exception
          Rails.logger.info "--- Record with ID already exists"
          retries += 1

          if retries == 4
            Rails.logger.info "Maximum number of retries reached"
            break
          end
        end
      end
      false
    else
      super(*args, &block)
    end
  end

  private
  def set_uuid
    if self.id.nil?
      if ActiveRecord::Base.connection.instance_of? ActiveRecord::ConnectionAdapters::SQLite3Adapter
        resources_with_numeric_ids = self.class.where("TYPEOF(id) = 'integer'")
      else
        resources_with_numeric_ids = self.class.where("id REGEXP '^[0-9]+$'")
      end

      self.id = resources_with_numeric_ids
        .maximum('CAST(id AS UNSIGNED)')
        .to_i + 1
    end
  end
end