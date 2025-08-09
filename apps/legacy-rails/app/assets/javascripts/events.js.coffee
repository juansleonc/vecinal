# $(document).on "change", "#event_receiver_type", ->
#   if $(this).val() == "users"
#     $.getScript("/events/selection_changed_user")
#   else if $(this).val() == "companies"
#     $.getScript("/events/selection_changed_company")
#   else if $(this).val() == "buildings"
#     $.getScript("/events/selection_changed_building")
#   else
#     $('#new-event-select-recipients').empty().val(null).change()

# $(document).on 'blur', '#event_date', ->
#   if $(this).val() == ''
#     $('#event_end_time').val('')
#   else
#     event_date = new Date($(this).val())
#     event_date.setHours(event_date.getHours() + 1)
#     $('#event_end_time').val(event_date.format('yyyy-mm-dd, h:MM tt'))

# $(document).ready ->
#   $("#event_receiver_type").change()
#   show_empty_container('#events', '.event')

$(document).on "submit", "#new_event", ->
    $('input[type=submit]').prop("disabled", true)