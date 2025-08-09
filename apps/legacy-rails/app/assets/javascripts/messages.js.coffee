# @update_messages_counters = ->
#   $('.all-messages-count').text($('#messages .message:not(.deleted, .done, .destroyed)').length)
#   $('.done-messages-count').text($('#messages .message.done').length)
#   $('.deleted-messages-count').text($('#messages .message.deleted').length)
#   unread_all = $('#messages .message:not(.deleted, .done, .destroyed).unread').length
#   unread_done = $('#messages .message.done.unread').length
#   unread_deleted = $('#messages .message.deleted.unread').length
#   $('.unread-all-messages-count').text(if unread_all > 0 then unread_all else '')
#   $('.unread-done-messages-count').text(if unread_done > 0 then unread_done else '')
#   $('.unread-deleted-messages-count').text(if unread_deleted > 0 then unread_deleted else '')

# show_empty_trash = ->
#   if $('#messages').hasClass('display-deleted')
#     $('#messages-empty-trash').removeClass('hidden')
#     $('#messages-new-message').addClass('hidden')
#   else
#     $('#messages-empty-trash').addClass('hidden')
#     $('#messages-new-message').removeClass('hidden')

# $(document).on 'focus', '.new-message textarea', (e) ->
#   if $(this).hasClass('big') == false
#     $(this).addClass('big')

# $(document).on 'blur', '.new-message textarea', (e) ->
#   if $(this).val() == ''
#     $(this).removeClass('big')

# $(document).on 'click', 'div.toggle-message', (e) ->
#   e.preventDefault()
#   if $(this).closest('.message').find('.message-content').hasClass('hidden')
#     $(this).closest('.message').find('.message-content').removeClass('hidden')
#     $(this).closest('.message').find('.content-aside').addClass('hidden')
#     $(this).closest('.message').find('.content-aside-bull').addClass('hidden')
#     $(this).closest('.message').find('.attachments').removeClass('hidden')
#     $(this).closest('.message').find('.commentable-comments, .comments-container').removeClass('hidden')
#   else
#     $(this).closest('.message').find('.content-aside').removeClass('hidden')
#     $(this).closest('.message').find('.content-aside-bull').removeClass('hidden')
#     $(this).closest('.message').find('.message-content').addClass('hidden')
#     $(this).closest('.message').find('.attachments').addClass('hidden')
#     $(this).closest('.message').find('.commentable-comments').addClass('hidden')

# $(document).on 'click', '.display-messages button', (e) ->
#   e.preventDefault()
#   $('#messages').removeClass('display-all')
#   $('#messages').removeClass('display-done')
#   $('#messages').removeClass('display-deleted')
#   $('#messages').addClass($(this).data('class'))
#   $('#messages-folder').text($(this).data('translation'))
#   $('#messages-folder-count').removeClass().addClass($(this).data('folder') + '-messages-count')
#   update_messages_counters()
#   show_empty_trash()
#   $('.display-messages button').removeClass('pressed')
#   $(this).addClass('pressed')
#   show_empty_container('#messages', '.message')

$(document).on "change", "#message_receiver_type", ->
  if $(this).val() == "users"
    $.getScript("/messages/selection_changed_user")
  else if $(this).val() == "companies"
    $.getScript("/messages/selection_changed_company")
  else if $(this).val() == "buildings"
    $.getScript("/messages/selection_changed_building")
  else
    $('#new-message-select-recipients').empty().val(null).change()

$(document).on 'click', '.messages-index .show-recipients-lits', ->
  $(this).closest('.recipients').find('.recipients-list').toggle()

$(document).ready ->
  $('#message_receiver_type').change()
  # update_messages_counters()
  # show_empty_trash()
  # show_empty_container('#messages', '.message')


