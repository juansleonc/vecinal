@update_apartments_counters = ->
  $('#all-apartments-count').text($('#apartments .single-apartment').length)
  $('#rent-apartments-count').text($('#apartments .single-apartment.for_rent').length)
  $('#sale-apartments-count').text($('#apartments .single-apartment.for_sale').length)

$(document).on 'click', '.apartments-filters a', (e) ->
  e.preventDefault()
  $('#apartments').removeClass('display-all')
  $('#apartments').removeClass('display-rent')
  $('#apartments').removeClass('display-sale')
  $('#apartments').addClass($(this).data('class'))
  $('.apartments-filters a').removeClass('active')
  $(this).addClass('active')

$(document).on 'change', '#apartment_show_price', ->
  if $(this).find('option:selected').val() == 'set_price'
    $('#apartment_price').removeAttr('disabled')
  else
    $('#apartment_price').attr('disabled', 'disabled')

$(document).on 'change', '#apartment_category', ->
  if $(this).find('option:selected').val() == 'for_rent'
    $('.furnished-pets-div').show()
  else
    $('.furnished-pets-div').hide()
  if $(this).find('option:selected').val() == 'only_display'
    $('#apartment_price').attr('disabled', 'disabled')
    $('#apartment_show_price').attr('disabled', 'disabled')
    $('#apartment_available_at').attr('disabled', 'disabled')
  else
    $('#apartment_show_price').removeAttr('disabled')
    $('#apartment_price').removeAttr('disabled') if $('#apartment_show_price').find('option:selected').val() == 'set_price'
    $('#apartment_available_at').removeAttr('disabled')

$(document).on 'change', '#apartment_show_contact', ->
  if $(this).find('option:selected').val() == 'other'
    $('#apartment_secondary_phone_number').removeAttr('disabled')
    $('#apartment_secondary_email').removeAttr('disabled')
  else
    $('#apartment_secondary_phone_number').attr('disabled', 'disabled')
    $('#apartment_secondary_email').attr('disabled', 'disabled')

$(document).ready update_apartments_counters