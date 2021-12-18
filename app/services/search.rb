# frozen_string_literal: true

class Search
  TYPES = %w[Question Answer User Comment].freeze

  def self.call(query, scope = nil)
    # TYPES.include?(scope) ? scope.to_s.capitalize.constantize.search(query) : ThinkingSphinx.search(query)
    if TYPES.include?(scope)
      scope.constantize.search(query)
    else
      # byebug
      ThinkingSphinx.search(query)
    end
  end
end
