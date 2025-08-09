calculate_fee = ($form) ->
  amount_base = $form.find('#amount_base').val()
  if $form.find('#method_debit').is(':checked')
    fee = $form.data('cm-fee')*1 + $form.data('platform-fee')*1
  else
    fee = (amount_base * $form.data('bank-percent')/100) + $form.data('cm-fee')*1 + $form.data('platform-fee')*1
  total = (amount_base * 1 + fee).toFixed(2)
  [fee, total]

$(document).on 'click', '.modal#new-payment-modal form button.submit', ->
  $form = $(this).closest('form')
  [fee, p_amount] = calculate_fee($form)
  p_cust_id_cliente = $form.find('#p_cust_id_cliente').val()
  p_key = $form.find('#p_key').val()
  p_id_invoice = $form.find('#p_id_invoice').val()
  p_currency_code = $form.find('#p_currency_code').val()
  $form.find('#p_signature').val(md5([p_cust_id_cliente, p_key, p_id_invoice, p_amount, p_currency_code].join('^')))
  $form.find('#p_amount, #p_amount_base').val(p_amount)
  $form.find('#p_extra2').val(fee)
  $form.submit()

$(document).on 'click', '.modal#new-payment-modal form #c-total', ->
  $form = $(this).closest('form')
  [fee, total] = calculate_fee($form)
  $form.find('#service-fee').text('$' + fee.toFixed(2))
  $form.find('#net-total').text('$' + total)
  $form.find('tr.total').show()

$(document).on 'click', '.modal#new-payment-modal #method_credit, .modal#new-payment-modal #method_debit', ->
  $(this).closest('form').find('tr.total').hide()

$(document).on 'change', '.modal#new-payment-modal #amount_base', ->
  $(this).closest('form').find('tr.total').hide()
