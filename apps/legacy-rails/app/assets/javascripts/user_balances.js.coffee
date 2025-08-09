@trigger_no_records_message = () ->
	if $('.user-balance:visible').size() == 0
  	$('.no-records').removeClass('hidden')

$('.yearpicker input').on 'change', ->
  year = $(this).val()
  window.location.replace('balances?type=year&filter=' + year)
  trigger_no_records_message()

$('.monthpicker input').on 'change', ->

  month = $(this).val()
  selected_building = $('#param-building').val()
  params = ''
  
  if selected_building > 0
    params = "b=" + selected_building

  query =  $('input[name=query]').val();

  if query.length > 0
    if selected_building > 0
      params += '&'
    params += 'query=' + query

  params = "#{params}&filter=#{month}"
  window.location.replace("#{request_path}?#{params}")
  trigger_no_records_message()

$('#new_account_balance').submit ->
  $('.modal#modal-spinner').modal backdrop: 'static'
  return