@update_reports_counters = ->
  impressions = clicks = acquisitions = revenue = 0
  customers = []
  $('.report').each ->
    if $(this).is(':visible')
      impressions += parseInt($(this).data('impressions'))
      clicks += parseInt($(this).data('clicks'))
      acquisitions += parseInt($(this).data('acquisitions'))
      if $(this).data('customers')
        $(this).data('customers').forEach( (id) ->  customers.push(id) if customers.indexOf(id) == -1 )
        revenue += parseFloat($(this).data('revenue'))
  $('#reports-impressions').text(impressions)
  $('#reports-clicks').text(clicks)
  $('#reports-acquisitions').text(acquisitions)
  $('#reports-customers').text(customers.length)
  $('#reports-revenue').text(revenue)

@count_vouchers = ->
  $('button.display-vouchers span#stuff-count-all').text($('table#vouchers tr.voucher').length)
  $('button.display-vouchers span#stuff-count-coupons').text($('table#vouchers tr.voucher.coupon').length)
  $('button.display-vouchers span#stuff-count-deals').text($('table#vouchers tr.voucher.deal').length)

$(document).on 'keyup', '#filter-promotions-input', ->
  js_filter('#filter-promotions-input', '#promotions .promotion');

$(document).on 'keyup', '#filter-reports-input', ->
  js_filter('#filter-reports-input', '#reports .report');
  update_reports_counters()

$(document).on 'keyup', '#filter-vouchers-input', ->
  js_filter('#filter-vouchers-input', '#vouchers .voucher');

$(document).on 'ready', ->
  $('.all-reports-count').text($('#reports .report').length)
  $('.coupons-reports-count').text($('#reports .report.coupon').length)
  $('.deals-reports-count').text($('#reports .report.deal').length)
  update_reports_counters()
  count_vouchers()

$(document).on 'click', '.display-reports button', (e) ->
  e.preventDefault()
  $('#reports').removeClass('display-all')
  $('#reports').removeClass('display-coupons')
  $('#reports').removeClass('display-deals')
  $('#reports').addClass($(this).data('class'))
  $('.display-reports button').removeClass('pressed')
  $(this).addClass('pressed')
  statistic_revenue = $('#reports-revenue').closest('div.statistic')
  if $(this).data('class') == 'display-coupons' then statistic_revenue.hide() else statistic_revenue.show()
  update_reports_counters()

$(document).on 'click', 'button.display-vouchers', (e) ->
  e.preventDefault()
  $('#vouchers').removeClass('display-all')
  $('#vouchers').removeClass('display-coupons')
  $('#vouchers').removeClass('display-deals')
  $('#vouchers').addClass($(this).data('class'))
  $('button').removeClass('pressed')
  $(this).addClass('pressed')
