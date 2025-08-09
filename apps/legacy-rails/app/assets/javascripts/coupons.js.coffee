$(document).on 'change', '#coupon_show_contact', ->
  if $(this).find('option:selected').val() == 'other'
    $('#coupon_secondary_phone_number').removeAttr('disabled')
    $('#coupon_secondary_email').removeAttr('disabled')
  else
    $('#coupon_secondary_phone_number').attr('disabled', 'disabled')
    $('#coupon_secondary_email').attr('disabled', 'disabled')

calc_coupon_price = ->
  value1 = if $('#coupon_show_highlight').is(':checked') then $("select#coupon_highlight_days option:selected").data('price') else 0
  value2 = if $('#coupon_show_top').is(':checked') then $("select#coupon_top_days option:selected").data('price') else 0
  total = value1 + value2
  $('span#coupon_amount_to_pay').text(total)

coupon_show_option_change = (option, select_container) ->
  if option.is(':checked')
    select_container.show()
    $('div#coupon_stripe_card').show()
    $('#div_coupon_amount_to_pay').removeClass('hidden')
  else
    select_container.hide()
  calc_coupon_price()

unchecked_both_coupon_payments = ->
  if !($('#coupon_show_highlight').is(':checked') || $('#coupon_show_top').is(':checked'))
    $('div#coupon_stripe_card').hide()
    $('#div_coupon_amount_to_pay').addClass('hidden')
    $('#payment_option').val('card_on_file')

$(document).on 'change', '#coupon_show_highlight', ->
  coupon_show_option_change($('#coupon_show_highlight'), $('#div_coupon_highlight_days'))
  unchecked_both_coupon_payments()

$(document).on 'change', '#coupon_show_top', ->
  coupon_show_option_change($('#coupon_show_top'), $('#div_coupon_top_days'))
  unchecked_both_coupon_payments()

$(document).on 'change', 'select#coupon_highlight_days', calc_coupon_price
$(document).on 'change', 'select#coupon_top_days', calc_coupon_price

$(document).ready coupon_show_option_change($('#coupon_show_highlight'), $('#div_coupon_highlight_days'))
$(document).ready coupon_show_option_change($('#coupon_show_top'), $('#div_coupon_top_days'))
