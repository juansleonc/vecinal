$(document).on 'click', '.reservations .reservation a.toggle-details', (e) ->
  e.preventDefault()
  $tbody = $(this).closest('tbody')
  $tbody.toggleClass('open-details')
  $tbody.find('td.reservation-details .commentable-comments, td.reservation-details .comments-container').toggleClass('hidden')
$(document).on 'click', '#new_user #community-selector .dropdown-menu li > a', ->
  if $(this).data('role') == 'Propietario' || $(this).data('role') == 'Owner'
    $('#administrative-role-selector').hide()
    $('#member-role-selector').show()
  else
    $('#administrative-role-selector').show()
    $('#member-role-selector').hide()
  $(this).closest('.form-group').find('#user_role').val($(this).data('role'))
