$(document).on 'keyup', '#new_company #company_name', ->
  $('#company_namespace').val($(this).val().toLowerCase().replace(/(^[\s\W]+|[\s\W]+$)/g, '').replace(/[\s\W]+/g, '-'))

# $(document).on 'blur', '#company_namespace', ->
#   $(this).val($(this).val().toLowerCase())

$(document).on 'click', '.company-select-plan', ->
  $('.company-selected-plan').addClass('hidden')
  $('.company-select-plan').removeClass('hidden')
  $(this).addClass('hidden')
  $(this).prev('.company-selected-plan').removeClass('hidden')
  $('input#plan_id').val($(this).data('plan'))
  $('tr.plan-detail').addClass('hidden')
  $('tr.plan-detail#' + $(this).data('plan')).removeClass('hidden')


