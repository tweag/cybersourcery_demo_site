$ ->
  # only show a drop down list of states if the selected country is the US
  $('#payment_bill_to_address_country').change ->
    if $(this).val() == 'US'
      $('#payment_bill_to_address_state').replaceWith($('#payment_bill_to_address_state_select_template').clone().prop({ id: 'payment_bill_to_address_state'}))
    else
      $('#payment_bill_to_address_state').replaceWith($('#payment_bill_to_address_state_input_template').clone().prop({ id: 'payment_bill_to_address_state'}))


  # strip non-numeric characters from the credit card field
  $('#payment_card_number').change ->
    value = $(this).val().replace(/[^\d\.]/g, '')
    $(this).val(value)

  # populate the card_expiry_date field from the expiry month and year
  $('#new_payment').submit ->
    $('#payment_card_expiry_date').val($('#payment_card_expiry_dummy_2i').val() + '-' + $('#payment_card_expiry_dummy_1i').val())
    # Cybersource generally ignores fields its not expecting, but sending arrays it's not expecting
    # causes a 500 server error, so remove the payment[card_expiry_dummy] fields!
    $('#payment_card_expiry_dummy_3i').remove()
    $('#payment_card_expiry_dummy_2i').remove()
    $('#payment_card_expiry_dummy_1i').remove()
