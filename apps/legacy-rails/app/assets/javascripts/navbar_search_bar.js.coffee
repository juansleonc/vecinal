$(document).on 'focus blur', 'form#navbar-remote-search-form input.form-control', ->
  $(this).closest('.input-group').toggleClass('focused')

$(document).on 'click', 'form#navbar-remote-search-form button', (e) ->
  e.preventDefault()
  $form = $(this).closest('form')
  $form.submit() if $form.find('input').val().length > 0

$(document).on 'click', '.search-selector .dropdown .dropdown-menu li > a', (e) ->
  e.preventDefault()
  $(this).closest('.dropdown').find('.dropdown-toggle span.text').html($(this).html())
  $('form#navbar-remote-search-form').prop('action', $(this).data('action'))

$(document).on 'click', '.search-selector button.re-search', ->
  $('form#navbar-remote-search-form').submit() if $('form#navbar-remote-search-form input').val().length > 0

$(document).on 'blur', 'form#navbar-remote-search-form-mobile input', ->
  $('form#navbar-remote-search-form input').val($(this).val())

#$(document).on 'click', 'form#navbar-remote-search-form-mobile button', (e) ->
#  e.preventDefault()
#  $('form#navbar-remote-search-form').submit() if $('form#navbar-remote-search-form input').val().length > 0
