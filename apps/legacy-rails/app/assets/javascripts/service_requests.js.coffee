@reset_modal = -> 
  $modal = $('.modal')
  $modal.find('.user-name').show()
  $modal.find('.logo-wrapper').show()
  $modal.find('.open-as-button').removeClass('hidden')
  $modal.find('.publisher-selector').addClass('hidden')

$(document).on 'click', '.open-as-button', (event) ->
  event.preventDefault()
  $('.modal .user-name').hide()
  $('.modal .logo-wrapper').hide()
  $('.modal .publisher-selector').removeClass('hidden')
  $('.modal .close-publisher-selector').removeClass('hidden')
  $(this).addClass('hidden')

$(document).on 'click', "a[data-toggle='modal']", ->
  reset_modal()
  $('.modal .close-publisher-selector').addClass('hidden')

$(document).on 'click', '.close-publisher-selector', ->
  reset_modal()
  $("#service-request-publisher").val("");
  $(this).addClass('hidden')

# Forgotten Coffescript Code

# @update_service_requests_counters = ->
#   $('.open-service-requests-count').text($('#service-requests .service-request:not(.closed)').length)
#   $('.pending-service-requests-count').text($('#service-requests .service-request.pending').length)
#   $('.in-progress-service-requests-count').text($('#service-requests .service-request.in_progress').length)
#   $('.closed-service-requests-count').text($('#service-requests .service-request.closed').length)
#   unread_open = $('#service-requests .service-request:not(.closed).unread').length
#   unread_pending = $('#service-requests .service-request.pending.unread').length
#   unread_in_progress = $('#service-requests .service-request.in_progress.unread').length
#   unread_closed = $('#service-requests .service-request.closed.unread').length
#   $('.unread-open-service-requests-count').text(if unread_open > 0 then unread_open else '')
#   $('.unread-pending-service-requests-count').text(if unread_pending > 0 then unread_pending else '')
#   $('.unread-in-progress-service-requests-count').text(if unread_in_progress > 0 then unread_in_progress else '')
#   $('.unread-closed-service-requests-count').text(if unread_closed > 0 then unread_closed else '')

#   $("#service-requests-navbar .responsibles-filter li a").each ->
#     if $(this).data("responsible-type") == "all"
#       $(this).find(".responsible-service-requests-count").text($('#service-requests .service-request:not(.cancelled)').length)
#       $('.all-responsible-service-requests-count').text($('#service-requests .service-request:not(.cancelled)').length)
#     else
#       $(this).find(".responsible-service-requests-count").text($('#service-requests .service-request[data-responsible-type="' + $(this).data("responsible-type") + '"][data-responsible-id="' + $(this).data("responsible-id") + '"]:not(.cancelled)').length)

# mark_service_requests_as_read = (ids, skip_notification = "no") ->
#   $.getScript("/service_requests/mark_as_read?&ids[]=" + ids.join('&ids[]=') + "&skip_notification=" + skip_notification);

# $(document).on 'click', '.unread .toggle-service-request', (e) ->
#   e.preventDefault()
#   mark_service_requests_as_read([$(this).closest('.unread').data('id')], "no")

# $(document).on 'focus', '.new-service-request textarea', (e) ->
#   if $(this).hasClass('big') == false
#     $(this).addClass('big')

# $(document).on 'blur', '.new-service-request textarea', (e) ->
#   if $(this).val() == ''
#     $(this).removeClass('big')

# $(document).on 'click', '.toggle-service-request', (e) ->
#   e.preventDefault()
#   if $(this).closest('.service-request').find('.service-request-content').hasClass('hidden')
#     $(this).closest('.service-request').find('.service-request-content').removeClass('hidden')
#     $(this).closest('.service-request').find('.attachments').removeClass('hidden')
#     $(this).closest('.service-request').find('.commentable-comments, .comments-container').removeClass('hidden')
#   else
#     $(this).closest('.service-request').find('.service-request-content').addClass('hidden')
#     $(this).closest('.service-request').find('.attachments').addClass('hidden')
#     $(this).closest('.service-request').find('.commentable-comments').addClass('hidden')

# $(document).on 'click', '.display-service-requests button', (e) ->
#   e.preventDefault()
#   $('#service-requests').removeClass('display-open')
#   $('#service-requests').removeClass('display-pending')
#   $('#service-requests').removeClass('display-in-progress')
#   $('#service-requests').removeClass('display-closed')
#   $('#service-requests').addClass($(this).data('class'))
#   $('.display-service-requests button').removeClass('pressed')
#   $(this).addClass('pressed')
#   $('#service-requests-navbar #service-requests-title').text($(this).data('translation'))
#   $('#service-requests-navbar #service-requests-folder-count').removeClass().addClass($(this).data('folder') + '-service-requests-count')
#   update_service_requests_counters()
#   show_empty_container('#service-requests', '.service-request')

# $(document).on 'click', '.display-service-requests-responsibles li a', (e) ->
#   e.preventDefault()
#   $('#service-requests .service-request').removeClass('responsibles-hidden')

#   if $(this).data('responsible-type') != 'all'
#     console.log $(this).data('responsible-type') + "  " + $(this).data('responsible-id')
#     $('#service-requests .service-request:not([data-responsible-type="' + $(this).data('responsible-type') + '"][data-responsible-id="' + $(this).data('responsible-id') + '"])').addClass('responsibles-hidden')

#   $('#service-requests-navbar #filter-2 span.text').text($(this).text())


# $(document).ready ->
#   update_service_requests_counters()
#   show_empty_container('#service-requests', '.service-request')

# $(document).on 'change', '.service-request-select-update', ->
#   $changed_select = $(this)
#   swal {
#     title: $changed_select.data('message')
#     type: 'warning'
#     showCancelButton: true
#     confirmButtonText: $changed_select.data('swal-confirm-yes')
#     cancelButtonText: $changed_select.data('swal-confirm-no')
#   }, (isConfirm) ->
#     if isConfirm
#       z_index = $changed_select.closest('div.service-request').css('z-index')
#       $.post($changed_select.data('path'), { field: $changed_select.attr('name'), value: $changed_select.val(), z_index: z_index })
#       $changed_select.data('original', $changed_select.val())
#     else
#       $changed_select.val($changed_select.data('original'))

# $(document).on 'click', 'div.count-comments', ->
#   $('.commentable-comments').toggleClass('no-form')