$('#new-account-balance-modal').ready ->
  
  $('*[data-picker="months"]')
    .datepicker({
      format: "yyyy/mm",
      startView: "months",
      minViewMode: "months",
      autoclose: true
    })
