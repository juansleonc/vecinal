module Reviewable
  extend ActiveSupport::Concern

  included do
    has_many :reviews, as: :reviewable, dependent: :destroy
  end

  def average_rank
    reviews.average(:rank).to_f
  end

  def reviews_by_rank(rank)
    reviews.where rank: rank
  end

  def percent_reviews_by_rank(rank)
    return 0 if reviews.count == 0
    (reviews_by_rank(rank).count.to_f/reviews.count.to_f) * 100
  end

end