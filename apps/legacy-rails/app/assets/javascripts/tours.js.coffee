finish_tour = ->
  # When we finish the tour we want to store change a boolean in the DB to not autoplay it again.
  $.post '/users/finish_tour'
  return

Shepherd.on 'start', ->
  #$('#shepherd-tour-overlay').stop(true, true).fadeIn 100
  return

Shepherd.on 'complete', ->
  finish_tour()
  return

Shepherd.on 'cancel', ->
  finish_tour()
  return

$(document).ready ->
  tour = new Shepherd.Tour
    defaults:
      classes: 'shepherd-element shepherd-open shepherd-theme-arrows'
      showCancelLink: true

  last_index = $("#shepherd-tour").find(".shepherd-tour-step").length - 1

  $("#shepherd-tour").find(".shepherd-tour-step").each (index) ->
    selector = $(this).data("attach").split(" ").slice(0, $(this).data("attach").split(" ").length - 1).join(" ")

    if $(selector).length > 0
      tour.addStep '.shepherd-tour-step-17',
        title: $(this).data("title")
        text: $(this).data("description")
        attachTo: $(this).data("attach")
        buttons: [
          {
            text: if index == 0 then $("#shepherd-tour").data("exit") else $("#shepherd-tour").data("back")
            classes: 'shepherd-button-secondary'
            action: if index == 0 then tour.cancel else tour.back
          }
          {
            text: if index == last_index then $("#shepherd-tour").data("finish") else $("#shepherd-tour").data("next")
            action: if index == last_index then tour.complete else tour.next
          }
        ]

  if $("#shepherd-tour").data("autoplay") == "yes" and tour.steps.length > 0 and $(window).width > 767
    tour.start()

  $(document).on 'click', '#take-a-tour', (e) ->
    e.preventDefault()
    $(".navbar .submenu-links .dropdown-group").addClass("always-open")
    tour.start()
