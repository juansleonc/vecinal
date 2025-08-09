$(document).on 'click', '.edit-amenity input[type=checkbox]', ->
  $value_input = $(this).closest('.form-group').find('input[type=number]')
  if $(this).is(':checked')
    $value_input.prop('disabled', false)
  else
    $value_input.prop('disabled', true)

$(document).on 'click', '.edit-amenity .availability-types input[type=radio]', ->
  $availabilities = $(this).closest('form.edit_amenity').find('.avalilabilities-container')
  if $(this).get(0).value == 'selected_hours'
    $availabilities.removeClass('hidden')
  else
    $availabilities.addClass('hidden')

$('#calendar').fullCalendar({
    height: 'auto',
    events: '/reservations.json?amenity_id=' + $('#reservation_amenity_id').val()
});