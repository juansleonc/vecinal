@count_redemptions_redeemed = ->
  redeemed = 0
  $('.redemption').each ->
    redeemed++ if $(this).data('redeemed')
  $('#redemptions-redeemed').text(redeemed)

$(document).on 'ready', count_redemptions_redeemed