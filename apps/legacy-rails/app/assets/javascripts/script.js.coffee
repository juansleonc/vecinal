# select2 methods
@receiver_selector_template = (option) ->
  return option.text if !option.id
  $('<div class="select2-receiver-selector-item">' +
    '<img src=' + $(option.element).data('logo') + '/>' +
    '<span class="black">' + $(option.element).data('name') + '</span>' +
    '<span class="details">' + $(option.element).data('details') + '</span>' +
    '</div>'
  )

@set_nav_option = (nav, option) ->
  nav.find(option).addClass('current')

@sum_reports = ->
  $('.report table').each ->
    sum_columns_table($(this))
    
@sum_columns_table = (table) ->
  col1_sum = 0
  col2_sum = 0

  table.find('td.col1').each ->
    col1_sum += parseInt($(this).text())
  table.find('.total1').text(col1_sum)

  table.find('td.col2').each ->
    col2_sum += parseInt($(this).text())
  table.find('.total2').text(col2_sum)

@receiver_selector_template_selection = (option) ->
  $(option.element).data('name') || option.text

@select2_format_build = (container) ->
  container.select2({
    placeholder: container.data('prompt') || 'Search',
    minimumInputLength: 1,
    templateResult: receiver_selector_template,
    templateSelection: receiver_selector_template_selection
  })

@select2_format_build_no_search = (container) ->
  container.select2({
    minimumResultsForSearch: -1,
    templateResult: receiver_selector_template,
    templateSelection: receiver_selector_template_selection
  })

@select2_multiple_with_format_launch = ->
  $('select.select2-multiple-with-format').each ->
    select2_format_build($(this))

@select2_single_with_format_launch = ->
  $('select.select2-single-with-format').each ->
    select2_format_build_no_search($(this))

@select2_with_format_ajax_launch = ->
  $('select.select2-with-format-ajax').each ->
    $(this).select2({
      theme: 'bootstrap',
      minimumInputLength: 1,
      language: $(this).data('lang'),
      placeholder: $(this).data('placeholder'),
      ajax: {
        url: $(this).data('path'),
        data: (params) -> { query: params.term },
        delay: 500,
        dataType: 'json',
        processResults: (data, params) -> { results: data },
      },
      templateResult: (option) ->
        return option.text if !option.id
        if option.apartment_numbers.length 
          location = '<br><span>' + option.apartment_numbers + ' - ' + option.accountable + '</span>'
        else if option.accountable.length
          location = '<br><span>' + option.accountable + '</span>'
        else
          location = ''

         
        $('<div class="select2-receiver-selector-item">
          <div class="logo-wrapper"><img src=' + option.logo + '/><span class="no-logo-letter">' + option.letter + '</span></div>'+
          '<div><span class="black">' + option.text + '</span>'+
          location +
          '</div></div>'
        )
    })

$(document).on 'focus', 'select.select2-multiple-with-format + span.select2-container input.select2-search__field', ->
  $('span.select2-dropdown').hide() if $(this).val() == ''

$(document).on 'keyup', '.select2-multiple-with-format + span.select2-container input.select2-search__field', ->
  if $(this).val() == ''
    $('span.select2-dropdown').hide()
  else
    $('span.select2-dropdown').show()

# end select2 methods

@show_blocking_alert = ->
  if $('#blocking_message').text().trim() != ''
    swal({ title: '', text: $('#blocking_message').text(), type: $('#blocking_message').data('type'), timer: 15000, confirmButtonColor: '#2978f6'})

@enable_popover = ->
  $('[data-toggle="popover"]').popover()

@enable_tooltip = ->
  $('[data-toggle="tooltip"]').tooltip()

$(document).on 'keyup', 'textarea.autoheight', ->
  $(this).innerHeight(0)
  $(this).innerHeight(@scrollHeight)

$(document).on 'focus', 'textarea.autoheight', ->
  $(this).innerHeight(@scrollHeight)

$(document).on 'click', '.input-group.receivers-selector .input-group-btn li a', (e) ->
  e.preventDefault()
  $selector = $(this).closest('.receivers-selector')
  $(this).closest('form').find($selector.data('target')).val($(this).data('type')).change()
  $selector.find('#receivers-selector-icon').removeClass().addClass('fa ' + $(this).data('icon'))
  $selector.find('.input-group-btn li a i.fa-check').addClass('hidden')
  $(this).find('i.fa-check').removeClass('hidden')

load_google_maps = ->
  $('.google-map').each ->
    drop_main = $(this).data('drop-main')
    drop_sec = $(this).data('drop-sec')
    markers = [{
      latitude: $(this).data('latitude')
      longitude: $(this).data('longitude')
      html: $(this).data('name')
      icon:
        image: drop_main || 'http://maps.google.com/mapfiles/ms/micons/red-dot.png'
        iconsize: [
          26
          46
        ]
        iconanchor: [
          12
          46
        ]
        infowindowanchor: [
          12
          0
        ]
    }]
    markers = markers.concat($(this).data('markers')) if $(this).data('markers')
    $(this).gMap
      controls:
        zoomControl: true
      scrollwheel: false
      draggable: true
      markers: markers
      icon:
        image: drop_sec || 'http://maps.google.com/mapfiles/ms/micons/green-dot.png'
        iconsize: [
          26
          46
        ]
        iconanchor: [
          12
          46
        ]
        infowindowanchor: [
          12
          0
        ]
      latitude: $(this).data('latitude')
      longitude: $(this).data('longitude')
      zoom: $(this).data('zoom') || 12

@launch_toastr_messages = ->
  $('.toastr-messages').each ->
    if $(this).text().trim() != ''
      if $(this).data('type') == 'success'
        toastr.success($(this).text())
      else if $(this).data('type') == 'error'
        toastr.error($(this).text())

@clean_form = ($form) ->
  $form.find('.form-errors-container').empty()
  $form.find('input[type=text]').val('')
  $form.find('input[type=number]').val('')
  $form.find('textarea').val('')
  $form.find('div.emoji-wysiwyg-editor').empty()
  $form.find('.attachments-container').empty()

@launch_time_picker = () ->
  $('.trigger-timepicker').datetimepicker({
    format: 'h:mm a',
    icons: {
      up: 'fa fa-chevron-up'
      down: 'fa fa-chevron-down'
    }
  })
  $('.trigger-timepicker-from').datetimepicker({
    format: 'h:mm a',
    icons: {
      up: 'fa fa-chevron-up'
      down: 'fa fa-chevron-down'
    }
  })
  $('.trigger-timepicker-to').datetimepicker({
    format: 'h:mm a',
    icons: {
      up: 'fa fa-chevron-up'
      down: 'fa fa-chevron-down'
    }
  })
  
@addZero = (i) ->
  if (i < 10)
    i = "0" + i;
  return i;

$(document).ready ->
  $('.time_from').change ->
    selected_time_from = $(this).val()
    $.ajax
      url: '/get_limit_time'
      method: 'post'
      dataType: 'json'
      data:{
        date_selected: $('.hidden-selected-date').val()
        amenity_id: $('.hidden-amenity-id').val() 
      }
      success: (amenity) ->
        dt = new Date();
        split_time_from = selected_time_from.split(':');
        dt.setHours(split_time_from[0], split_time_from[1] )
        t_from = dt.getHours()
        available_hours = 24 - t_from
        set_available_hours = if available_hours > amenity.reservation_length then amenity.reservation_length else available_hours 
        
        dt.setHours(dt.getHours() + set_available_hours )
        if dt.getMinutes() < 10
          minutes = '0' + dt.getMinutes()
        else
          minutes = dt.getMinutes()
        if dt.getHours() < 10
          hour = '0' + dt.getHours()
        else
          hour = dt.getHours()
        
        if hour == '00'
          hour = 24
        
        time_to = hour + ':' + minutes

        reserved_time = null
        $('#reservation_time_to > option').each ->
          $(this).hide()
          if $(this).attr('disabled-tmp') == 'true'
            $(this).removeAttr('disabled-tmp')
            $(this).prop("disabled", false);
          
          if this.value < selected_time_from 
            $(this).attr('disabled-tmp', 'true')
            $(this).prop("disabled", true);

          if $(this).hasClass('option-selected') && selected_time_from < this.value
            reserved_time = $(this).hasClass('option-selected')
            
          if reserved_time == null
            unless time_to < this.value || reserved_time != null
              $(this).prop('selected', true)

          if  time_to < this.value || reserved_time != null
            $(this).attr('disabled-tmp', 'true')
            $(this).prop("disabled", true);
          $(this).show()
        return

@get_operating_schedule = () ->
  $.ajax
    url: '/get_operating_schedule'
    method: 'post'
    dataType: 'json'
    data:{
      date_selected: $('.hidden-selected-date').val()
      amenity_id: $('.hidden-amenity-id').val()
    }
    success: (operating_schedule) ->
      if operating_schedule.length
        operating_schedule.map (reservation) ->
          split_time_from = reservation.time_from.split('T');
          split_time_from = split_time_from[1].split('.');
          time_from = split_time_from[0].slice(0,-3);
          split_time_to = reservation.time_to.split('T');
          split_time_to = split_time_to[1].split('.');
          time_to = split_time_to[0].slice(0,-3);
          if time_to == '00:00'
            time_to = '24:00'
          $('#reservation_time_from > option').each ->
            if this.value < time_from 
              $(this).hide()
            if this.value == time_from 
              $(this).prop('selected', true)              
            if  this.value > time_to
              $(this).hide()
          $('#reservation_time_to > option').each ->
            if this.value < time_from 
              $(this).hide()
            if  this.value > time_to
              $(this).hide()
      $('.time_from').change()
      return


@launch_date_picker = () ->
  $('#filter_month').datepicker({ format: "yyyy-mm-dd", autoclose: true }).on('changeDate', ->
    window.location.href = window.location.origin + '/amenities/' + $('#reservation_amenity_id').val() + '/calendar?date=' + $(this).val()
  )
  $('.trigger-datepicker').datepicker({ format: "yyyy-mm-dd", autoclose: true }).on('changeDate', ->

    $('.hidden-selected-date').val($(this).val())
    $('.hidden-amenity-id').val($(this).closest('form').find('#reservation_amenity_id').val())
    
    
    $.ajax
      url: '/get_reservation_schedule'
      method: 'post'
      dataType: 'json'
      data:{
        date_selected: $(this).val()
        amenity_id: $('.hidden-amenity-id').val() 
      }
      success: (schedule) ->

        selection = ''
        i = 0

        zeroFill = (number, width) ->
          width -= number.toString().length
          if width > 0
            return new Array(width + (if /\./.test(number) then 2 else 1)).join('0') + number
          number + ''
        
        interval = $('#reservation_reservation_interval').val()

        i = 0
        while i <= 24
          j = zeroFill(i, 2)
          selection += '<option value=\'' + j + ':00\'>' + j + ':00' + '</option>'
          if interval < 1 && i < 24
            selection += '<option value=\'' + j + ':30\'>' + j + ':30' + '</option>'
          i++

        
        $( '.select-timepicker2' ).html('');
        $( '.select-timepicker2' ).append(selection);
        get_operating_schedule();
        schedule.map (reservation) ->
          split_time_from = reservation.time_from.split('T');
          split_time_from = split_time_from[1].split('.');
          time_from = split_time_from[0].slice(0,-3);
          split_time_to = reservation.time_to.split('T');
          split_time_to = split_time_to[1].split('.');
          time_to = split_time_to[0].slice(0,-3);
          if time_to == '00:00'
            time_to = '24:00'
          $('#reservation_time_from > option').each ->
            if this.value >= time_from && this.value <= time_to
              this.disabled = true 
              $(this).addClass('option-selected')
          $('#reservation_time_to > option').each ->
            if this.value >= time_from && this.value <= time_to 
              this.disabled = true 
              $(this).addClass('option-selected')
        return
      error: ->
        console.log 'No se ha podido obtener la información'
        return

  )

@launch_date_picker_birthday = () ->
  $('.trigger-datepicker-birthday').datepicker({ format: 'mm-dd', autoclose: true }).on('show', ->
    dateText = $(".datepicker-days .datepicker-switch").text().split(" ")
    $(".datepicker-days .datepicker-switch").text(dateText[0])
    $(".datepicker-months table thead tr th").css({"visibility":"hidden"})
  ).on('hide', ->
    $input_target = $($(this).data('target'))
    if $(this).val().trim() == ''
      $input_target.val(null)
    else
      $input_target.val(new Date($(this).val()).format('yyyy-mm-dd'))
  )

@launch_datetime_picker = () ->
  $('.trigger-datetimepicker').datetimepicker({
    format: "YYYY-MM-DD, h:mm a",
    icons: {
      time: 'fa fa-clock-o'
      date: 'fa fa-calendar'
      up: 'fa fa-chevron-up'
      down: 'fa fa-chevron-down'
      previous: 'fa fa-chevron-left'
      next: 'fa fa-chevron-right'
      today: 'fa fa-crosshairs'
      clear: 'fa fa-trash'
    }
  })

@launch_monthpicker = () ->
  $(".monthpicker").datepicker({
    format: "yyyy/mm",
    viewMode: "months", 
    minViewMode: "months",
    autoclose: true
  });

@launch_yearpicker = () ->
  $(".yearpicker").datepicker({
    format: "yyyy",
    viewMode: "years", 
    minViewMode: "years",
    autoclose: true
  });

@update_communities_filter_counters = ->
  $filter = $('#communities-filter')
  $('.all-items-count').text($($filter.data('items')).not('.Public-0').length)
  $('#communities-filter .dropdown-menu li a').slice(1).each ->
    $(this).find('.items-count').text($($filter.data('items') + '.' + $(this).data('class')).length)

filter_all_dropdown_filters = ($items) ->
  $('.dropdown-filter').each ->
    selected = $(this).data('selected')
    if (selected == 'display-all' || selected == undefined)
      $('div').filter('.Hidden').hide()
      $('[data-user="resident"] div').filter('.Reported').hide()
    else
      $items.not('.' + selected + ', .Public-0').hide()
      $items.filter('.Public-0').removeClass('hidden') if selected == 'Public-0'

@lauch_textarea_autosize = ->
  $('textarea.js-auto-size').textareaAutoSize()

@hide_no_visible_elements = ->
  $("div").filter(".Hidden").hide()
  $('[data-user="resident"] div').filter('.Reported').hide()

$(document).on 'click', '.modal-or-remote', (e) ->
  e.preventDefault()
  if $($(this).data('target')).length
    $($(this).data('target')).modal()
  else
    $.getScript($(this).data('path'))

$(document).on 'click', '.autohide-finder a', ->
  $(this).prev('input').toggle().focus()
  $(this).toggleClass('active')

$(document).on 'blur', '.autohide-finder input', ->
  if $(this).next('a:hover').length == 0
    $(this).hide()
    $(this).next('a').removeClass('active')

$(document).on 'click', '.cm-navbar .navbar-header a.navbar-brand', (e) ->
  e.preventDefault()
  $(this).closest('.navbar-header').find('ul.dropdown-menu').toggle()
  $(this).toggleClass('mobile-open') if $(window).width() < 576

$(document).on 'keyup', '.filter-input-js', ->
  search_text = $(this).val()
  $items = $($(this).data('items'))
  filter_all_dropdown_filters($items)
  if search_text.trim() == ''
    $items.show()
  else
    $items.each (index) ->
      array_of_words = search_text.trim().split(/\s+/)
      all_found = true
      data_search = $(this).text()
      $.each array_of_words, (index, value) ->
        regex_var = new RegExp(value, 'i')
        if data_search.match(regex_var) == null then all_found = false
      if all_found == true then $(this).show() else $(this).hide()

# list group items
$(document).on 'click', '.cm-list .list-group-item.with-content', ->
  $.get($(this).data('read-path')) if $(this).hasClass('unread')
  $('.list-group-item-content:visible .close-item-content').click()
  $(this).hide()
  $($(this).data('target')).show()

$(document).on 'click', '.cm-list .list-group-item-content a.toggle-comments', (e) ->
  e.preventDefault()
  $(this).closest('.content').find('.commentable-comments').toggle()

$(document).on 'click', '.comments-replies', ->
  $(this).next('.commentable-comments').toggle()

$(document).on 'click', '.for-closed', ->
  $comments = $('.commentable-comments')
  $comments.toggle()
  $comments.toggleClass('space-top')
  $('.new-commentable-comment').hide()

$(document).on 'click', '.replies-and-likes .toggle-comments', (e) ->
  e.preventDefault()
  $(this).closest('.replies-and-likes').next('.commentable-comments').toggle()

$(document).on 'click', '.list-group-item-content .close-item-content', (e) ->
  e.stopPropagation()
  $content = $(this).closest('.list-group-item-content')
  $content.prev('li.list-group-item').show()
  $content.hide()

$(document).on 'click', '.list-group-item .confirm-destroy, .list-group-item-content .confirm-destroy', (e) ->
  e.stopPropagation()
# end list group items

$(document).on 'click', '.dropdown-filter:not(.no-js) ul.dropdown-menu li a', (e) ->
  e.preventDefault()
  $dropdown = $(this).closest('.dropdown-filter')
  $dropdown.find('.dropdown-toggle span.text').html($(this).html())
  $dropdown.data('selected', $(this).data('class'))
  $items = $($dropdown.data('items'))
  $items.not('.Public-0').show()
  $items.filter('.Public-0').addClass('hidden')
  filter_all_dropdown_filters($items)

$(document).on 'click', '.dropdown.as-select ul.dropdown-menu li > a', (e) ->
  e.preventDefault()
  $dropdown = $(this).closest('.dropdown.as-select')
  $dropdown.closest('form').find($dropdown.data('target')).val($(this).data('id'))
  $dropdown.closest('form').find($dropdown.data('target-type')).val($(this).data('type'))
  $dropdown.find('.dropdown-toggle > span').html($(this).html())

$(document).on 'click', '.dropdown.shareable ul.dropdown-menu li > a', (e) ->
  e.preventDefault()
  $(this).closest('.dropdown-menu').find('li > a').removeClass('checked')
  $(this).addClass('checked')



$(document).on 'click', 'a.confirm-destroy', (e) ->
  e.preventDefault()
  $(this).parent().find('.confirmed-destroy').addClass('to-be-destroyed')
  swal {
    title: ''
    text: $(this).data('swal-confirm')
    type: 'warning'
    showCancelButton: true
    confirmButtonText: $(this).data('swal-confirm-yes')
    cancelButtonText: $(this).data('swal-confirm-no')
    confirmButtonColor: '#2978f6'
  }, (isConfirm) ->
    if isConfirm
      $('.to-be-destroyed').click()
      location.reload()
    else
      $('.to-be-destroyed').removeClass 'to-be-destroyed'
    return

$(document).on 'click', '.toggle-chevron', ->
  $(this).toggleClass('fa-chevron-down fa-chevron-up')

$(document).scroll ->
  $load_more = $('.load-more-at-bottom').first()
  if $load_more.length && ($(document).height() <= window.scrollY + window.innerHeight)
    next_path = $load_more.data('next-path')
    $.getScript(next_path) if next_path

$(document).on 'click', '.timeline-view .profile-about form table tbody tr td a.edit', (e) ->
  e.preventDefault()
  $(this).closest('form').addClass('editable')
  $(this).closest('td').addClass('hidden')
  $(this).closest('tr').find('td.to-edit').removeClass('hidden')

$(document).on 'click', '#append_message_to_outgoing_notifications', (e) ->
  e.preventDefault()
  $(this).closest('form').addClass('editable')
  $(this).closest('.content-options').addClass('hidden')
  $(this).closest('form').find('.to-edit').removeClass('hidden')


$(document).on 'click', '#notification_mail_signature', (e) ->
  e.preventDefault()
  $(this).closest('form').addClass('editable')
  $(this).closest('.content-options').addClass('hidden')
  $(this).closest('form').find('.to-edit').removeClass('hidden')

$(document).on 'click', '#profile-and-notifications a#cancel-changes', (e) ->
  e.preventDefault()
  $form = $(this).closest('form')
  $form.removeClass('editable')
  $(this).closest('.content-options').removeClass('hidden')
  $(this).closest('form').find('.to-edit').addClass('hidden')

$(document).on 'click', '.timeline-view .profile-about form a#cancel-changes', (e) ->
  e.preventDefault()
  $form = $(this).closest('form')
  $form.removeClass('editable')
  $form.find('table tbody tr td').removeClass('hidden')
  $form.find('table tbody tr td.to-edit').addClass('hidden')

$(document).on 'click', '.reservation.unread, .message.unread, .service-request.unread', ->
  $.getScript($(this).data('mark-as-read-path'))

$(document).on 'click', '.receivers-list-modal ul > li > a', (e) ->
  e.preventDefault()
  $(this).closest('li').addClass('active').siblings().removeClass('active')
  $(this).closest('.modal-body').find($(this).data('target')).addClass('active').siblings().removeClass('active')

# Popover with conent events (beta)
$(document).on 'click', '.toggle-popover', ->
  $popover = $('#' + $(this).data('toggle'))
  $popover.css({
    top: $(this).position().top + 35,
    left: $(this).position().left + 125
  })

  $popover.removeClass('hidden')

$(document).ready ->
  hide_no_visible_elements()
  launch_date_picker()
  launch_time_picker()
  launch_datetime_picker()
  launch_date_picker_birthday()
  launch_monthpicker()
  launch_yearpicker()
  enable_popover()
  enable_tooltip()
  $('span.timeago').timeago()
  update_communities_filter_counters() if $('#communities-filter').length
  launch_toastr_messages()
  load_google_maps()
  select2_multiple_with_format_launch()
  select2_single_with_format_launch()
  select2_with_format_ajax_launch()
  show_blocking_alert()
  $("reported-icon").tooltip()
  lauch_textarea_autosize()
  $( window ).scroll (e) ->
    $( "#menu_bottom" ).css( "display", "none" ).fadeIn( "slow" );
    
$(document).on 'ajax:success', (e, data, status, xhr) ->
  enable_popover();
  $('textarea.js-auto-size').css('height', 'initial')
  lauch_textarea_autosize()

$(document).on 'click', '.switcher-content li a', (e) ->
  e.preventDefault()
  $(this).closest('li').addClass('active').siblings().removeClass('active')
  $('.switchable').removeClass('visible')
  $($(this).data('target')).addClass('visible')


$('#communities-filter-new').find('.dropdown-menu li a').each ->
  urlParams = new URLSearchParams(window.location.search);
  search = if urlParams.get('c') then '?c='+urlParams.get('c') else '?b='+urlParams.get('b');
  if search != '?b=' && search != '?c='
    if $(this).attr('href').includes(search)
      console.log $(this).attr('href')
      $('#communities-filter-new').find('button .text').html($(this).html())    

$(document).on 'click', '.toggle-comments.after-rule, .comments-replies', (e) ->
  data_comment = $(this).attr 'data_comment'
  id_data_comment = '#' + data_comment  
  if $(id_data_comment).css('display') == 'block' 
    $.ajax(url: "/comments/load_timeline_comment",type: 'post',data: {data_comment: data_comment}).done (html) ->
      $(id_data_comment + ' .commentable-comment').remove()
      $(id_data_comment).append html
      $('span.timeago').timeago()

$('.element-filter').click ()->
  selected = $(this).data('class');
  selected2 = $(this).attr('href');
  classselected = "." + selected;
  if selected == 'all'
    $('.print-report').each ->
      print_report = $(this).attr('href');
      if print_report.indexOf('building') > -1
        print_report = print_report.substr(0,print_report.indexOf('building'));
        $(this).attr('href',print_report);
      
    $('.panel-content').height(300);
    $('#comments-table table tbody tr').each (index, tr) ->
      $(tr).show();
    $('#messages-table table tbody tr').each (index, tr) ->
      $(tr).show();
    $('#service_requests-table table tbody tr').each (index, tr) ->
      $(tr).show();
    $('#events-table table tbody tr').each (index, tr) ->
      $(tr).show();
    $('#attachments-table table tbody tr').each (index, tr) ->
      $(tr).show();
    $('#amenities-table table tbody tr').each (index, tr) ->
      $(tr).show();
    $('#polls-table table tbody tr').each (index, tr) ->
      $(tr).show();
    $('#payments-table table tbody tr').each (index, tr) ->
      $(tr).show();
  else
    
    $('.print-report').each ->
      print_report = $(this).attr('href');
      split_selected = selected2.split('?');
      if split_selected[1].length > 0
        params_selected = split_selected[1].split('&');
        if params_selected[2].length > 0
          id_selected = params_selected[2].split('=');
          print_report = print_report + '&building=' + id_selected[1];
          $(this).attr('href', print_report);
          print_report = $(this).attr('href');
      
    $('#comments-table table tbody tr').each (index, tr) ->
      $(tr).show();
      if $(tr).hasClass(selected) == false
        $(tr).hide();
      else
      
      
    $('#messages-table table tbody tr').each (index, tr) ->
      $(tr).show();
      if $(tr).hasClass(selected) == false
        $(tr).hide();
      else
      
    $('#service_requests-table table tbody tr').each (index, tr) ->
      $(tr).show();
      if $(tr).hasClass(selected) == false
        $(tr).hide();
      else
      
    $('#events-table table tbody tr').each (index, tr) ->
      $(tr).show();
      if $(tr).hasClass(selected) == false
        $(tr).hide();
      else
      
    $('#attachments-table table tbody tr').each (index, tr) ->
      $(tr).show();
      if $(tr).hasClass(selected) == false
        $(tr).hide();
      else
      
    $('#amenities-table table tbody tr').each (index, tr) ->
      $(tr).show();
      if $(tr).hasClass(selected) == false
        $(tr).hide();
      else
      
    $('#polls-table table tbody tr').each (index, tr) ->
      $(tr).show();
      if $(tr).hasClass(selected) == false
        $(tr).hide();
      else
    $('#payments-table table tbody tr').each (index, tr) ->
      $(tr).show();
      if $(tr).hasClass(selected) == false
        $(tr).hide();
      else
    $('.panel-content').height(120);
    
return 

$(document).on 'turbolinks:load', ->
  $('.tag-tooltip').tooltip()
  return