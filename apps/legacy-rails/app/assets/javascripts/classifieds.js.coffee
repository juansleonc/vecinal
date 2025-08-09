$('#new_classified').submit ->
    $('.modal#modal-spinner').modal backdrop: 'static'
    $('#new_classified input[type=submit]').prop "disabled", true
    return