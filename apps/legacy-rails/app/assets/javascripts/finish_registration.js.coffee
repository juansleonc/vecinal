$(document).on 'mouseover', '.finish-registration .finish-registration-role', () ->
  $(this).addClass('selected')

$(document).on 'mouseleave', '.finish-registration .finish-registration-role', () ->
  $(this).removeClass('selected')

$(document).on 'click', '.finish-registration-communities .ask-to-join', (e) ->
  e.preventDefault()
  $form = $(this).closest('form')
  $form.find('#user_accountable_code').val($(this).data('code'))
  $form.submit()

$(document).ready ->
  $('.finish-registration-communities #communities .community.selected').first().prependTo('.finish-registration-communities #communities')