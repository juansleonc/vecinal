module UserBalancesHelper
  def capitalize_every_word word
    word.split.map(&:capitalize).join(' ')
  end
end