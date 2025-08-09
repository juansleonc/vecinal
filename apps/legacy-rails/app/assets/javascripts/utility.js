function disable_element(element, text){
  if($(element).is('a')){
    $(element).addClass('disabled');
    $(element).attr('re-enable-with', $(element).text());
    $(element).text($(element).attr('disable-with'));
  }
  if($(element).is('input')){
    $(element).addClass('disabled');
    $(element).attr('re-enable-with', $(element).val());
    $(element).val($(element).attr('disable-with'));
  }
  if($(element).is('textarea')){
    $(element).attr('readonly', 'readyonly');
    $(element).attr('re-enable-with', 're-enable');
  }
}

function re_enable_elements(){
  $('[re-enable-with]').each(function(){
    $(this).removeClass('disabled');

    if($(this).is('a')){
      $(this).text($(this).attr('re-enable-with'));
    }
    if($(this).is('input')){
      $(this).val($(this).attr('re-enable-with'));
    }
    if($(this).is('textarea')){
      $(this).removeAttr('readonly');
    }
    $(this).removeAttr('re-enable-with');
  });
}

$(document).on("change", ".js-update-field", function(){
  $.post($(this).data('path'), { field: $(this).attr('name'), value: $(this).val() });
});

function js_filter($my_filter, items){
  var search_text = $my_filter.val();
  if (search_text.trim() == '') {
    return $(items).show();
  }
  else {
    return $(items).each(function(index) {
      var all_found = '';
      var array_of_words = '';
      var data_search = ''
      array_of_words = search_text.trim().split(/\s+/);
      all_found = true;
      data_search = $(this).text();
      $.each(array_of_words, function(index, value) {
        var regex_var = '';
        regex_var = new RegExp(value, 'i');
        if (data_search.match(regex_var) == null){
          return all_found = false;
        }
      });
      if (all_found == true) $(this).show();
      else $(this).hide();
    });
  }
}

function js_date_filter(filter_from, filter_to, items) {
  var date_from;
  var date_to;
  if ($(filter_from).val().trim() === ''){
    date_from = 0;
  }
  else{
    date_from = Date.parse($(filter_from).val());
  }
  if ($(filter_to).val().trim() === ''){
    date_to = Date.parse('2200-01-01');
  }
  else{
    date_to = Date.parse($(filter_to).val());
  }
  $(items).each(function(){
    var sale_date = Date.parse($(this).data('date'));
    if (sale_date < date_from || sale_date > date_to){
      $(this).hide();
    }
  });
}

function userAgentIsMobile() {
  return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
}

function setCookie(cname, cvalue, exdays, path) {
  var d = new Date();
  d.setTime(d.getTime() + exdays*24*60*60*1000);
  var expires = "expires="+ d.toUTCString();
  document.cookie = cname + "=" + cvalue + "; " + expires + "; path=" + path;
}

function isiPhone() {
  return ((navigator.platform.indexOf("iPhone") != -1) || (navigator.platform.indexOf("iPod") != -1));
}


$(document).ready(function(){
  $('#new-service-request-modal form, #new_message, #new_amenity').submit(function(){    
    $(this).find('input[type=submit]').prop('disabled',true);
  });
});
if (typeof edit !=  'undefined'){
  if(edit == 'true'){
    $(document).ready(function () {
      $('.show-amenity .modal-or-remote').click();
    });
  }
}