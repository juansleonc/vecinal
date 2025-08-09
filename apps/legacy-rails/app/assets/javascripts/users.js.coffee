$(document).on 'change', '.profile-settings form input', ->
  $(this).closest('form').addClass('editable')

$(document).on 'click', '.profile-settings form .dropdown .dropdown-menu li > a', ->
  $(this).closest('form').addClass('editable')

$(document).on 'click', '.profile-settings form a#cancel-changes', (e) ->
  e.preventDefault()
  $(this).closest('form').removeClass('editable')

$(document).on 'change', '.devise.need-help input[name=devise_need_help]', () ->
  $(this).closest('form').attr('action', $(this).val()) if $(this).is(':checked')

$(document).on 'click', '.bulk-import-a', () ->
  $('#user_first_name').prop('required',false);
  $('#user_last_name').prop('required',false);
  $('#user_email').prop('required',false);
  $('#apartment_number').prop('required',false);

$(document).on 'click', '.single-invitation', () ->
  $('#user_first_name').prop('required',false);
  $('#user_last_name').prop('required',false);
  $('#user_email').prop('required',false);
  $('#apartment_number').prop('required',false);

$(document).on 'click', '.change-role', () ->
  $('#user_accountable_type').val($(this).attr('data-accountable-type'))
  console.log($(this).attr('data-accountable-type'))


$('#user_password, #user_password_confirmation').keyup () ->
  user_password = $('#user_password').val()
  user_password_confirmation = $('#user_password_confirmation').val()
  if user_password.length > 0
    if user_password == user_password_confirmation
      disabled_continue();
      $('.form-group.row.error').hide();
    else
      $( "#btn-change-password" ).prop( "disabled", false );
      $('.form-group.row.error').show();
  else
    $( "#btn-change-password" ).prop( "disabled", false );
    $('.form-group.row.error').show();
  return
  
disabled_continue = () -> 
  if( $('#terms').prop('checked') ) 
    $( "#btn-change-password" ).prop( "disabled", false );
  else
    $( "#btn-change-password" ).prop( "disabled", true );
  return 

$('#terms').click () ->
  user_password = $('#user_password').val()
  user_password_confirmation = $('#user_password_confirmation').val()
  if user_password.length > 0
    if user_password == user_password_confirmation
      disabled_continue();
      $('.form-group.row.error').hide();
    else
      $( "#btn-change-password" ).prop( "disabled", false );
      $('.form-group.row.error').show();
  else
    $( "#btn-change-password" ).prop( "disabled", false );
    $('.form-group.row.error').show();
  return
# ---

$(document).ready ->
  $('.resend').click ->
    swal '', resend, 'success'
    return
  return