@update_reviews_counters = (avg, count) ->
  $("#reviews .reviews-average span.average").text(avg)
  $("#reviews .reviews-average span.count").text(count)

@update_star_bars = ->
  $('#reviews .reviews-average #stars-bars .star-bar').each ->
    out_width = $(this).closest('#stars-bars').find('.star-number').width() + 15
    $(this).css('width', 'calc(100% - ' + out_width + 'px)')
    $bar = $(this).find('.bar')
    in_width = $(this).find('.votes-count').width() + 5
    $bar.css('width', 'calc(' + $bar.data('width') + '% - ' + in_width + 'px)')

$(document).on 'click', '.modal#new-review-modal form#new_review a.review-star', (e) ->
  e.preventDefault()
  $(this).closest('form').find('input#review_rank').val($(this).data('rank'))
  $(this).siblings().removeClass('selected')
  $(this).addClass('selected')

$(document).on 'mouseover', '.modal#new-review-modal form#new_review a.review-star', ->
  $(this).closest('form').find('p.rank-name').text($(this).data('name'))

$(document).on 'mouseleave', '.modal#new-review-modal form#new_review a.review-star', ->
  $form = $(this).closest('form')
  $selected = $form.find('a.review-star.selected')
  $form.find('p.rank-name').text(if $selected.length == 0 then '' else $selected.data('name'))

$(document).on 'click', '#reviews .new-review a', ->
  rank = $(this).data('rank')
  $sel_star = $('#new-review-modal').find('form .stars-container .stars a[data-rank=' + rank + ']')
  $('#new-review-modal').find('form input#review_rank').val(rank)
  $('#new-review-modal').find('form .stars-container .stars a').removeClass('selected')
  $sel_star.addClass('selected')
  $('#new-review-modal').find('form p.rank-name').text($sel_star.data('name'))

$(document).ready ->
  update_star_bars()
