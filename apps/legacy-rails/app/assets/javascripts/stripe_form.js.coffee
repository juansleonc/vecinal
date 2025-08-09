form = $("form.stripe-card-form")
error = $(".alert-danger", form)
success = $(".alert-success", form)

form.validate
  doNotHideMessage: true #this option enables to show the error/success messages on tab switch.
  errorElement: "span" #default input error message container
  errorClass: "help-block" # default input error message class
  focusInvalid: false # do not focus the last invalid input
  rules:
    # Billing Info
    card_number:
      required: true
      digits: true
      minlength: 12
      maxlength: 19
    card_code:
      required: true
      digits: true
      minlength: 3
      maxlength: 4
    card_month:
      required: true
    card_year:
      required: true
  errorPlacement: (error, element) -> # render error placement for each input type
    error.insertAfter element # for other inputs, just perform default behavior
  invalidHandler: (event, validator) -> #display error alert on form submit
    if ($('#payment_option').val() == 'another_card')
      success.hide()
      error.show()
  highlight: (element) -> # hightlight error inputs
    $(element).closest(".form-group").removeClass("has-success").addClass("has-error") # set error class to the control group
  unhighlight: (element) -> # revert the change done by hightlight
    $(element).closest(".form-group").removeClass("has-error") # set error class to the control group
  success: (label) ->
    # mark the current input as valid and display OK icon
    label.addClass("valid").closest(".form-group").removeClass("has-error").addClass("has-success") # set success class to the control group
  submitHandler: (form) ->
    error.hide()
    $('#stripe_error').hide()
    # add here some ajax code to submit your form or just call form.submit() if you want to submit the form without ajax
    $('#buy-btn').attr("disabled", true).val("Please Wait...")
    $('#card_number, #card_code, #card_month, #card_year').removeAttr('name')
    stripeResponseHandler = (status, response) ->
      if status == 200
        $('#stripe_card_token').val(response.id)
        form.submit()
      else
        success.hide()
        $('#stripe_error')
        .show()
        .text(response.error.message)
        .addClass('alert alert-danger alert-dismissable')
        $('input[type=submit]').attr('disabled', false).val('Please Try Again')
    # If the credit card form is present
    if ($('#payment_option').val() == 'another_card') && $('#card_number').length
      Stripe.card.createToken(form, stripeResponseHandler)
      return false
    else # If the credit card token has already been received
      form.submit()

change_payment_option = ->
  if ($('#payment_option').val() == 'another_card')
    $('div#stripe-card-fields').show()
  else
    $('div#stripe-card-fields').hide()

$(document).on 'change', '#payment_option', change_payment_option
$(document).ready change_payment_option