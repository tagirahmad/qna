# frozen_string_literal: true

module ApplicationHelper
  def collection_cache_key_for(model)
    model_stringified = model.to_s
    klass = model_stringified.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_fs, :number)
    "#{model_stringified.pluralize}/collection-#{count}-#{max_updated_at}"
  end
end
