# @update_contact_counters = ->
#   $('.company-contacts-count').text($('#contacts .contact.company').length)
#   $('.all-contacts-count').text($('#contacts .contact').length)
#   $("#contacts-navbar ul li a[data-class='display-building']").each () ->
#     $(this).find('span.building-contacts-count').text $("#contacts .contact.building[data-building-id='" + $(this).data('building-id') + "']").length

# $(document).ready ->
#   update_contact_counters()
#   show_empty_container('#contacts', '.contact')

# $(document).on 'click', '.display-contacts li a', (e) ->
#   e.preventDefault()
#   $("#contacts .contact").removeClass('hidden')
#   if $(this).data('class') == 'display-company'
#     $("#contacts .contact:not(.company)").addClass('hidden')
#   else if $(this).data('class') == 'display-building'
#     $("#contacts .contact.building:not([data-building-id='" + $(this).data('building-id') + "'])").addClass('hidden')
#   $('#contacts-navbar button span.text').text($(this).text().trim())
#   show_empty_container('#contacts', '.contact')

# $(document).on 'click', '.toggle-request', (e) ->
#   e.preventDefault()
#   if $(this).closest('.request').find('.contact-content').hasClass('hidden')
#     $(this).closest('.request').find('.contact-content').removeClass('hidden')
#   else
#     $(this).closest('.request').find('.contact-content').addClass('hidden')

getProfileBannerTimeout = undefined

$(document).on 'mouseover', '.with-profile-banner', (e) ->
  id = $(this).data('user-id')
  $banner = $('.profile-banner#' + id)
  getProfileBannerTimeout = setTimeout( ->
    if $banner.length
      $banner.css( {'left': e.pageX, 'top': e.pageY} ).show()
    else
      [window.mouseX, window.mouseY] = [e.pageX, e.pageY]
      $.getScript('/users/profile_banner/' + id)
  , 500)

$(document).on 'mouseleave', '.with-profile-banner', ->
  clearTimeout(getProfileBannerTimeout)
  $('.profile-banner').hide() unless $('.profile-banner:hover').length

$(document).on 'mouseleave', '.profile-banner', ->
  $(this).hide()


