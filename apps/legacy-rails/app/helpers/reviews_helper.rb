module ReviewsHelper

  def review_avg_stars(revieable)
    rank = revieable.average_rank
    stars = []
    Review::MAX_RANK.times do |i|
      if rank == 0
        return t('reviews.no_reviews')
      elsif rank > i && rank < i + 1
        stars << '<i class="fa fa-star-half-o"></i>'
      elsif rank >= i + 1
        stars << '<i class="fa fa-star"></i>'
      elsif rank < i + 1
        stars << '<i class="fa fa-star-o"></i>'
      end
    end
    stars.join(' ').html_safe
  end

end
