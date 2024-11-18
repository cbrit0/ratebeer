class Style < ApplicationRecord
  has_many :beers

  def average_rating
    beers_with_ratings = beers.includes(:ratings).select { |beer| beer.ratings.any? }
    return 0.0 if beers_with_ratings.empty?

    total_score = beers_with_ratings.sum { |beer| beer.average_rating * beer.ratings.size }
    total_ratings = beers_with_ratings.sum { |beer| beer.ratings.size }

    total_score / total_ratings
  end

  def self.top(n)
    all.sort_by(&:average_rating).reverse.first(n)
  end
end
