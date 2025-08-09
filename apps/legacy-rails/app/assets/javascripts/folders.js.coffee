show_actions_buttons = ($element) ->
  $actions = $('.folders .path-container .actions #dynamic-actions')
  $actions.css('display', 'inline')
  $actions.find('a.confirmed-destroy').attr('href', $element.data('path'))
  $actions.find('a.edit').attr('data-target', $element.data('target'))
  if $element.data('download-url')
    $actions.find('a.download').attr('href', $element.data('download-url')).attr('download', $element.data('file-name'))
    $actions.find('a.download').show()
  else
    $actions.find('a.download').hide()

@hide_action_buttons = ->
  $actions = $('.folders .path-container .actions #dynamic-actions')
  $actions.hide()
  $actions.find('a.confirmed-destroy').attr('href', '')
  $actions.find('a.edit').attr('data-target', '')
  $actions.find('a.download').attr('href', '').attr('download', '')

$(document).on 'click', '.folders .add-attachments-folder-button', (e) ->
  e.preventDefault()
  $('form#add-attachments-folder input#attachment_file_attachments').click()

$(document).on 'change', 'form#add-attachments-folder input#attachment_file_attachments', ->
  $input = $(this)
  $files = $(this).get(0).files
  
  if $files.length > $input.data('max-files')
    toastr.error($input.data('max-files-error'))
  else
    valid = true
    $.each $files, (k, file) ->
      if file.size > $input.data('max-file-size')
        toastr.error $input.data('max-file-size-error')
        valid = false
        return false
    if valid
      console.log('this is size ', $files.length)
      #$(this).closest('form').submit()

      $.ajax
        type: 'POST'
        enctype: 'multipart/form-data'
        url: $(this).closest('form').attr('action')
        data: new FormData($('#add-attachments-folder')[0]);
        processData: false
        contentType: false
        cache: false
        timeout: 600000



      $('.modal#modal-spinner').modal({ backdrop: 'static' });
  $input.get(0).value = ''


$(document).on 'click', '.folders .change-folder-mode', ->
  $(this).closest('.inner-section.folders').toggleClass('list-mode')
  if $(this).closest('.inner-section.folders').hasClass('list-mode')
    setCookie('list_mode', 'true', 360, '/folders')
  else
    setCookie('list_mode', '', 0, '/folders')

$(document).on 'dblclick', '.folders .link-dblclick', ->
  $(this).find('a.link-dblclick-target')[0].click()

$(document).on 'click', '.folders .link-dblclick', (e) ->
  e.stopPropagation()
  if userAgentIsMobile()
    $(this).find('a.link-dblclick-target')[0].click()
  else
    $('.link-dblclick').not($(this)).removeClass('active')
    $(this).toggleClass('active')
    $('.contextual-menu').hide()
    if $(this).hasClass('active')
      show_actions_buttons $(this)
    else
      hide_action_buttons()

$(document).on 'contextmenu', '.folders .link-dblclick', (e) ->
  e.preventDefault()
  $('.folders .link-dblclick').removeClass('active')
  $(this).addClass('active')
  show_actions_buttons $(this)
  $('.folders .contextual-menu').hide()
  $(this).closest('.document').find('.contextual-menu').css(
    {'left': e.pageX - $(this).offset().left + 15, 'top': e.pageY - $(this).offset().top}
  ).show()

$(document).on 'click', '.folders .documents-container', ->
  $('.folders .link-dblclick').removeClass('active')
  hide_action_buttons()
  $('.folders .contextual-menu').hide()

$(document).on 'click', '.folders .new-and-search .finder a', ->
  $(this).prev('input').toggle().focus()
  $(this).toggleClass('active')

$(document).on 'blur', '.folders .new-and-search .finder input', ->
  if $(this).next('a:hover').length == 0
    $(this).hide()
    $(this).next('a').removeClass('active')

$(document).on 'click', '.folders .contextual-menu a.delete', (e) ->
  e.stopPropagation()
  $(this).closest('.folders').find('.path-container .actions a.confirm-destroy').click()


$(document).ready ->
  $('.fancybox').fancybox
    autoSize: true,
    type: 'iframe'
  return