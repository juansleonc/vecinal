$(document).on 'click', '.modal#new-payment-account-modal .buildings .dropdown-menu a', (e) ->
  $form = $(this).closest('form')
  $form.find('label#country').text($(this).data('country'))
  $form.find('input#payment_account_country').val($(this).data('cc'))
  $form.find('table').removeClass('CO CA US RD').addClass($(this).data('cc'))

$(document).on 'change', '.modal.payment-account #payment_account_country', (e) ->
  $(this).closest('table').removeClass('CO CA US RD').addClass($(this).val())