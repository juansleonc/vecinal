create_new_image_form = () ->
  time = new Date().getTime()
  regexp = new RegExp($('#add-image-button').data('id'), 'g')
  $('#add-image-button').closest('div.add-image-grid').after($('#add-image-button').data('fields').replace(regexp, time))

read_image_url_from_file_input = (input) ->
  if input.files and input.files[0]
    reader = new FileReader()
    reader.onload = (e) ->
      $(input).closest('div.image-div').find('img').attr('src', e.target.result)
    reader.readAsDataURL(input.files[0])

logo_changed = ->
  if $('#logo').val() == ""
    image_removed_actions()
  else
    image_selected_actions()

image_selected_actions = ->
  $('#remove_logo').prop('checked', false)

image_removed_actions = ->
  $('#logo').val("")
  $('#remove_logo').prop('checked', true)
  $('#new-logo').show()
  $('#current-logo').hide()

$(document).on 'click', '.remove-image', (e) ->
  $image_div = $(this).closest('.image-div')
  $image_div.find('input.destroy-image').val('1')
  $image_div.find('input.image-field').val('')
  $image_div.hide()
  e.preventDefault()

$(document).on 'click', '#add-image-button', (e) ->
  create_new_image_form() if $('div.images-container input.image-field').length == 0
  $(this).closest('div.add-image-grid').next().find('input.image-field').click()
  e.preventDefault()

$(document).on 'change', 'input.image-field', (e) ->
  e.preventDefault()
  if $(this).val() != ""
    types = /(\.|\/)(gif|jpe?g|png)$/i
    file = $(this).val()
    if types.test(file)
      read_image_url_from_file_input(this)
      $(this).closest('div').find('input[type=hidden]').val('0')
      create_new_image_form() if $(this).closest('div.images-container').length != 0
      $(this).closest('div.image-div').show()
    else
      $(this).val('')
      alert('file type now allowed')

$(document).on 'click', '.choose-image-button', (e) ->
  $(this).closest('div.image-container').find('input.image-field').click()
  e.preventDefault()

$(document).on 'click', '#remove-current-logo', (e)->
  e.preventDefault()
  $('#current-logo input').attr('disabled', true)
  $('#new-logo input').attr('disabled', false)
  image_removed_actions()

$(document).on 'change', '#logo', ->
  logo_changed()

$(document).on 'click', '.change-image-icon a.change-image', (e) ->
  e.preventDefault()
  $($(this).data('form-target')).find('input[type=file]').click()

$(document).on 'change', 'form#new-home-image input[type=file], form#new-logo input[type=file], form#new-images input[type=file]', ->
  $('.loading-overlay').fadeIn()
  $(this).closest('form').submit()


