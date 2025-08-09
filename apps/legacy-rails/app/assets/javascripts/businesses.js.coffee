$(document).on 'keyup', '#new_business #business_name', ->
  $('#business_namespace').val($(this).val().toLowerCase().replace(/\s+/g, '-'))

$(document).on 'keyup', '#filter-businesses-input', ->
  js_filter('#filter-businesses-input', '#businesses .business');

$(document).on 'keyup', '#filter-invoices-input', ->
  js_filter('#filter-invoices-input', '#invoices .invoice');
  js_date_filter('#filter-invoices-from-date-input', '#filter-invoices-to-date-input', '#invoices .invoice')

$(document).on 'change', '#filter-invoices-from-date-input, #filter-invoices-to-date-input', ->
  js_filter('#filter-invoices-input', '#invoices .invoice');
  js_date_filter('#filter-invoices-from-date-input', '#filter-invoices-to-date-input', '#invoices .invoice')

$(document).on 'click', '.business-select-plan', ->
  $('.business-selected-plan').addClass('hidden')
  $('.business-select-plan').removeClass('hidden')
  $(this).addClass('hidden')
  $(this).prev('.business-selected-plan').removeClass('hidden')
  $('input#plan_id').val($(this).data('plan'))
  $('tr.plan-detail').addClass('hidden')
  $('tr.plan-detail#' + $(this).data('plan')).removeClass('hidden')


