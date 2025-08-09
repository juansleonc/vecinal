/**
Built by Amaury Peniche
apeniche@gmail.com
**/

$(document).ready(function(){
  initialize_awesome_checkbox();
  $(document).on('change', '.awesome-checkbox.initialized', function(){
    $('label[for="'+ $(this).attr('id') +'"]').html(get_awesome_checkbox_icon(this) + ' ' + get_awesome_checkbox_label_content(this));
    toggle_awesome_checkbox_classes('label[for="'+ $(this).attr('id') +'"]', this)
  });

  // Lets observe mutations to the DOM to auto-initialize dynamically created checkboxes
  var observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutation) {
      if(mutation.type == 'childList'){
        initialize_awesome_checkbox();
      }
    });
  });

  var config = { childList: true, subtree: true };
  observer.observe($('body')[0], config);
});

function initialize_awesome_checkbox(){
  $('input[type="checkbox"].awesome-checkbox:not(.initialized)').each(function(index){
    $(this).before('<label class="awesome-checkbox-label ' + get_awesome_checkbox_label_class(this) + '" for="'+ $(this).attr('id') + '">' + get_awesome_checkbox_icon(this) + ' ' + get_awesome_checkbox_label_content(this) + '</label>');
    $(this).addClass('initialized');
  });
}

function toggle_awesome_checkbox_classes(label, checkbox){
  if($(checkbox).is(':checked')){
    if($(checkbox).data('label-class-unchecked') != undefined){
      $(label).removeClass($(checkbox).data('label-class-unchecked'));
    }
    if($(checkbox).data('label-class-checked') != undefined){
      $(label).addClass($(checkbox).data('label-class-checked'));
    }
  }else{
    if($(checkbox).data('label-class-checked') != undefined){
      $(label).removeClass($(checkbox).data('label-class-checked'));
    }
    if($(checkbox).data('label-class-unchecked') != undefined){
      $(label).addClass($(checkbox).data('label-class-unchecked'));
    }
  }
}

function get_awesome_checkbox_label_class(selector){
  var label_class = $(selector).is(':checked') ? $(selector).data('label-class-checked') : $(selector).data('label-class-unchecked');
  if(label_class == undefined){
    label_class = '';
  }
  return label_class;
}

function get_awesome_checkbox_label_content(selector){
  var content = $(selector).is(':checked') ? $(selector).data('label-content-checked') : $(selector).data('label-content-unchecked');
  if(content == undefined){
    content = '';
  }
  return content;
}

function get_awesome_checkbox_icon(selector){
  var icon = $(selector).is(':checked') ? $(selector).data('icon-checked') : $(selector).data('icon-unchecked');
  if(icon == undefined){
    return '';
  }else{
    return '<i class="' + icon + '"></i>';
  }
}