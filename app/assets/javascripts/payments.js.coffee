$ ->
  # only show a drop down list of states if the selected country is the US
  $('#bill_to_address_country').change ->
    if $(this).val() == 'US'
      $('#bill_to_address_state').replaceWith($('#bill_to_address_state_select_template').clone().prop({ id: 'bill_to_address_state'}))
    else
      $('#bill_to_address_state').replaceWith($('#bill_to_address_state_text_template').clone().prop({ id: 'bill_to_address_state'}))


  # strip non-numeric characters from the credit card field
  $('#card_number').change ->
    value = $(this).val().replace(/[^\d\.]/g, '')
    $(this).val(value)

  # populate the card_expiry_date field from the expiry month and year
  $('#payment_form').submit ->
    $('#card_expiry_date').val($('#card_expiry_month').val() + '-' + $('#card_expiry_year').val())
