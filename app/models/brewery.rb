class Brewery < ApplicationRecord
  include RatingAverage
  include Topable

  validates :name, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1040,
                                   only_integer: true }
  validate :year_not_greater_than_this_year

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  scope :active, -> { where active: true }
  scope :retired, -> { where active: [nil, false] }

  def year_not_greater_than_this_year
    errors.add(:year, "can't be greater than current year") if year > Time.now.year
  end

  def self.top(n)
    Brewery.all.sort_by(&:average_rating).reverse.first(n)
  end
end
