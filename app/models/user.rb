class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  validates :username, uniqueness: true,
                       presence: true,
                       length: { in: 3..30 }
  validate :password_complexity

  private

  def password_complexity
    # Checks that password is at least 4 characters long, includes at least one uppercase letter, and one digit
    return if password.present? && password.match?(/\A(?=.*[A-Z])(?=.*\d).{4,}\z/)

    errors.add(:password, "must be at least 4 characters long, and include at least one uppercase letter and one number")
  end
end
