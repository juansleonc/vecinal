$(document).on 'keyup', '#new_building #building_name', ->
  $('#building_subdomain').val($(this).val().toLowerCase().replace(/(^[\s\W]+|[\s\W]+$)/g, '').replace(/[\s\W]+/g, '-'))

$(document).on 'blur', '#building_subdomain', ->
  $(this).val($(this).val().toLowerCase())
