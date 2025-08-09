@update_payments_balance = ->
  balance = 0
  $('.sale').each ->
    if $(this).is(':visible')
      balance += parseFloat($(this).data('price'))
  $('#payments-balance').text(balance)

@count_purchases_redeemed = ->
  redeemed = 0
  $('.purchase').each ->
    redeemed++ if $(this).data('redeemed')
  $('#purchases-redeemed').text(redeemed)

$(document).on 'change', '#deal_purchase_quantity', ->
  $('#deal-purchase-total').text('$' + ($('#deal_purchase_price').val() * $(this).val()).toFixed(2))

$(document).on 'ready', ->
  count_purchases_redeemed()
  update_payments_balance()

$(document).on 'keyup', '#filter-sales-input', ->
  js_filter('#filter-sales-input', '#sales .sale');
  js_date_filter('#filter-sales-from-date-input', '#filter-sales-to-date-input', '#sales .sale')
  update_payments_balance()

$(document).on 'change', '#filter-sales-from-date-input, #filter-sales-to-date-input', ->
  js_filter('#filter-sales-input', '#sales .sale');
  js_date_filter('#filter-sales-from-date-input', '#filter-sales-to-date-input', '#sales .sale')
  update_payments_balance()

