module Topable
  extend ActiveSupport::Concern

  class_methods do
    def top(how_many)
      all.sort_by { |item| -(item.average_rating || 0) }[0, how_many]
    end
  end
end
