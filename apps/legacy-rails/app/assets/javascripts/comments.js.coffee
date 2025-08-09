# $(document).on 'keydown', '.new-commentable-comment textarea', (e) ->
#   if e.keyCode == 13
#     e.preventDefault()
#     disable_element(this)
#     $(this).closest('form').submit()

# $(document).on 'click', 'a.comment-count', ->
#   $(this).next('div.comments-container').toggleClass('hidden')

$(document).on 'click', '.cancel-comment', (e) ->
  e.preventDefault()
  $(this).closest('.commentable-comments').hide().prev('.comments-replies').show()
