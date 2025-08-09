$(document).on 'click', '#polls .poll form .answer input[type=radio]', ->
  $(this).closest('form').submit()

$(document).on 'click', '#polls .poll form .answer a.poll-answer', (e) ->
  e.preventDefault()
  $(this).closest('form').find('#poll_vote_poll_answer_id').val($(this).data('id'))
  $(this).closest('form').submit()