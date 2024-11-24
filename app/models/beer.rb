class Beer < ApplicationRecord
  include RatingAverage
  include Topable

  belongs_to :style
  belongs_to :brewery, touch: true
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user

  validates :name, presence: true
  validates :style, presence: true

  def to_s
    "#{name} #{brewery.name}"
  end

  def average
    return 0 if ratings.empty?

    ratings.map(:score).sum / ratings.count.to_f
  end
end
