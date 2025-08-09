$(document).ready ->
  set_nav_option($('.nav-chart'), '#user-option')
  create_line_chart({
    labels: $('#line-chart').data('labels'),
    series: $('#line-chart').data('series')  
  })
  sum_reports()
  $('.print-content').find('.nav-chart li a').attr('href', '#')
  $('.print-content').find('.nav-chart li a').removeClass('current')
  set_nav_option($('.print-content .nav-chart'), '#' + $('.nav-chart').data('option') + '-option')

  $('.chart-content-printable').each ->
    template = $(this).find('.line-chart')
    mount_point = template.attr('id')
    draw_line('#' + mount_point, { labels: template.data('labels'), series: template.data('series') })
    set_nav_option($(this).find('.nav-chart'), '#' + $(this).data('model') + '-option')

$(document).on 'click', '.chart-section .nav-chart li a', (e) ->
  e.preventDefault()
  $('.nav-chart li a').removeClass('current')
  $(this).addClass('current')

$(document).on 'click', '.date-filter li a', (e) ->
  e.preventDefault()
  $(this).closest('.dropdown').find('.date-option').text($(this).text())
  $(this).closest('.date-filter').find('.dropdown').removeClass('open')

$(document).on 'click', '#filter-communities-list li a', (e) ->
  e.preventDefault()
  $(this).closest('.dropdown').find('.dropdown-toggle span.option').html($(this).html())
  $(this).closest('.dropdown').removeClass('open')

update_chart = ->
  $('.line-chart').each ->
    $(this).get(0).__chartist__.update()

window.matchMedia('print').addListener(update_chart)