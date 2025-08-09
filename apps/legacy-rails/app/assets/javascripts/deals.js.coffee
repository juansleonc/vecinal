$(document).on 'change', '#deal_show_contact', ->
  if $(this).find('option:selected').val() == 'other'
    $('#deal_secondary_phone_number').removeAttr('disabled')
    $('#deal_secondary_email').removeAttr('disabled')
  else
    $('#deal_secondary_phone_number').attr('disabled', 'disabled')
    $('#deal_secondary_email').attr('disabled', 'disabled')

calc_deal_price = ->
  value1 = if $('#deal_show_highlight').is(':checked') then $("select#deal_highlight_days option:selected").data('price') else 0
  value2 = if $('#deal_show_top').is(':checked') then $("select#deal_top_days option:selected").data('price') else 0
  total = value1 + value2
  $('span#deal_amount_to_pay').text(total)

deal_show_option_change = (option, select_container) ->
  if option.is(':checked')
    select_container.show()
    $('div#deal_stripe_card').show()
    $('#div_deal_amount_to_pay').removeClass('hidden')
  else
    select_container.hide()
  calc_deal_price()

unchecked_both_deal_payments = ->
  if !($('#deal_show_highlight').is(':checked') || $('#deal_show_top').is(':checked'))
    $('div#deal_stripe_card').hide()
    $('#div_deal_amount_to_pay').addClass('hidden')
    $('#payment_option').val('card_on_file')

$(document).on 'change', '#deal_show_highlight', ->
  deal_show_option_change($('#deal_show_highlight'), $('#div_deal_highlight_days'))
  unchecked_both_deal_payments()

$(document).on 'change', '#deal_show_top', ->
  deal_show_option_change($('#deal_show_top'), $('#div_deal_top_days'))
  unchecked_both_deal_payments()

$(document).on 'change', 'select#deal_highlight_days', calc_deal_price
$(document).on 'change', 'select#deal_top_days', calc_deal_price

$(document).ready deal_show_option_change($('#deal_show_highlight'), $('#div_deal_highlight_days'))
$(document).ready deal_show_option_change($('#deal_show_top'), $('#div_deal_top_days'))

