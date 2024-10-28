module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    return nil if ratings.empty?

    total = ratings.map(&:score).reduce(:+)
    total.to_f / ratings.size
  end
end
