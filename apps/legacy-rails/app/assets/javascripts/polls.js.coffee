$(document).on 'click', 'input#poll_days_or_date_days', ->
  $('input#poll_duration').prop('disabled', false)
  $('input#poll_end_date_date').prop('disabled', true)

$(document).on 'click', 'input#poll_days_or_date_date', ->
  $('input#poll_duration').prop('disabled', true)
  $('input#poll_end_date_date').prop('disabled', false)

$(document).on 'click', 'a.delete-poll-answer', (e) ->
  e.preventDefault()
  $(this).closest('.form-group').remove()

$(document).on 'click', 'a.add-poll-answer', (e) ->
  e.preventDefault()
  sec = $(this).data('secuency')
  $(this).closest('form').find('.poll-answers-container').append(
    '<div class="form-group with-icon">\
      <input class="form-control" id="poll_poll_answers_attributes_' + sec + '_name" name="poll[poll_answers_attributes][' + sec + '][name]" placeholder="Add choice" skip_autolabel="true" type="text">\
      <a class="delete-poll-answer on-input" href="#"><i class="fa fa-close"></i></a>\
    </div>'
  )
  $(this).data('secuency', sec + 1)

@set_poll_answer_bg_width = ->
  $('#polls .poll .answer.answered').each ->
    gradient_params = '(left, #e3ebf0, #e3ebf0 ' + $(this).data('bg-width') + '%, transparent 0)'
    for style in ['-webkit-linear-gradient', '-o-linear-gradient', '-moz-linear-gradient', 'linear-gradient']
      $(this).css('background', style + gradient_params)

$(document).ready ->
  set_poll_answer_bg_width()

$(document).on 'click', '.polls a.see-all-polls', (e) ->
  e.preventDefault()
  $(this).closest('.building').find('.polls-container .poll.hidden').removeClass('hidden')
  $(this).hide()
