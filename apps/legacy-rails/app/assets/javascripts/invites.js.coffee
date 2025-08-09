$(document).on 'click', '.links-for-select-mode a', (e) ->
  e.preventDefault()
  $(this).addClass('active').siblings().removeClass('active')
  $(this).closest('form').removeClass('single-invitation bulk-import').addClass($(this).data('class'))
  $('#import_type').val($(this).data('class'))

$(document).on 'keyup', 'textarea#bulk_import', ->
  if $(this).val().split("\n").length > 1
    $(this).prop('rows', 8)
  else
    $(this).prop('rows', 4)

$(document).on 'click', '#new_invite #community-selector .dropdown-menu li > a', ->
  if $(this).data('role') == 'Propietario' || $(this).data('role') == 'Owner'
    $('#administrative-role-selector').hide()
    $('#member-role-selector').show()
  else
    $('#administrative-role-selector').show()
    $('#member-role-selector').hide()
  $(this).closest('.form-group').find('#user_role').val($(this).data('role'))