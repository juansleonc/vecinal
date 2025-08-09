# This is for models with many attachments
create_new_attachment_form = ($form_element) ->
  time = new Date().getTime()
  $button = $form_element.find('.add-attachment-button')
  regexp = new RegExp($button.data('id'), 'g')
  $form_element.find('div.attachments-container').append($button.data('fields').replace(regexp, time))

read_image_url_from_file_input = (input) ->
  if input.files and input.files[0]
    reader = new FileReader()
    reader.onload = (e) ->
      image = new Image()
      image.src = e.target.result
      width = 100
      height = 100
      margin_left = 0
      margin_top = 0
      # if image.height > image.width
      #   height = image.height / image.width * 100
      #   margin_top = (100 - height) / 2
      # else
      #   width = image.width / image.height * 100
      #   margin_left = (100 - width) / 2
      $(input).closest('div.attachment-div').find('img').attr('src', e.target.result)
    #   $(input).closest('div.attachment-div').find('img').css('height', height + '%')
    #   $(input).closest('div.attachment-div').find('img').css('width', width + '%')
    #   $(input).closest('div.attachment-div').find('img').css('max-width', width + '%')
    #   $(input).closest('div.attachment-div').find('img').css('margin-left', margin_left + '%')
    #   $(input).closest('div.attachment-div').find('img').css('margin-top', margin_top + '%')
    reader.readAsDataURL(input.files[0])

$(document).on 'click', '.remove-attachment', (e) ->
  e.preventDefault()
  $(this).closest('.attachment-div').find('input.destroy-attachment').val('1')
  $(this).closest('.attachment-div').find('input.attachment-field').val('')
  $(this).closest('.attachment-div').hide()
  # if $(this).closest('form').find('.attachments-container > div:visible').length == 0 and $(this).closest('form').data('hide-actions') == 'yes'
      # $(this).closest('form').find('.actions').hide()

$(document).on 'click', '.add-attachment-button', (e) ->
  e.preventDefault()
  all_formats = ".gif,.png,.jpeg,.jpg,.pdf,.doc,.docx,.ppt,.pptx,.xls,.xlsx"
  create_new_attachment_form($(this).closest('form')) if $(this).closest('form').find('input.attachment-field').length == 0
  $(this).closest('form').find('.attachment-div:last-child input.attachment-field').attr('accept', all_formats)
  $(this).closest('form').find('.attachment-div:last-child input.attachment-field').click()

$(document).on 'click', '.select-file', (e) ->
  e.preventDefault()
  $form = $('.new-timeline-comment form')
  create_new_attachment_form($form) if $form.find('input.attachment-field').length == 0
  formats = ".pdf,.doc,.docx,.ppt,.pptx,.xls,.xlsx,.gif,.png,.jpeg,.jpg"
  $form.find('.attachment-div:last-child input.attachment-field').attr('accept', formats)
  $form.find('.attachment-div:last-child input.attachment-field').click()

$(document).on 'change', 'input.attachment-field', (e) ->
  e.preventDefault()
  if $(this).val() != ""
    types = /(\.|\/)(gif|p?jpe?g|png|x-png|pdf|docx?|pptx?|xlsx?)$/i
    image_types = /(\.|\/)(gif|p?jpe?g|png|x-png)$/i
    file = $(this).val()
    if types.test(file)
      if image_types.test(file)
        read_image_url_from_file_input(this)
      else
        name_array = file.split('.')
        ext = name_array[name_array.length - 1]
        filename_array = file.split('\\')
        $(this).closest('.attachment-div').find('.image-holder').addClass(ext)
        $(this).closest('div.attachment-div').find('img').attr('src', $(this).data('images-map')[ext])
        $(this).closest('div.attachment-div').find('.image-holder').append('<span class="filename">' + filename_array[filename_array.length - 1].split('.')[0] + '</span>')
      $(this).closest('div').find('input[type=hidden]').val('0')
      create_new_attachment_form($(this).closest('form')) if $(this).closest('form').find('div.attachments-container').length != 0
      $(this).closest('div.attachment-div').show()
      if $(this).closest('form').data('hide-actions') == 'yes'
        $(this).closest('form').find('.actions').show()
    else
      $(this).val('')
      swal({type: 'error', title: '', text: 'File type now allowed', confirmButtonColor: '#2978f6' })

