$ ->
  # only show a drop down list of states if the selected country is the US
  $('#payment_bill_to_address_country').change ->
    if $(this).val() == 'US'
      $('#payment_bill_to_address_state').replaceWith($('#payment_bill_to_address_state_select_template').clone().prop({ id: 'payment_bill_to_address_state'}))
    else
      $('#payment_bill_to_address_state').replaceWith($('#payment_bill_to_address_state_input_template').clone().prop({ id: 'payment_bill_to_address_state'}))


  # strip non-numeric characters from the credit card field
  $('#card_number').change ->
    value = $(this).val().replace(/[^\d\.]/g, '')
    $(this).val(value)

  # populate the card_expiry_date field from the expiry month and year
  $('#payment_form').submit ->
    $('#card_expiry_date').val($('#payment_card_expiry_date_2i').val() + '-' + $('#payment_card_expiry_date_1i').val())

  # highlight missing fields if we fail client-side validation
  $('#payment_form .btn-primary').click ->
    # TODO: this is relying on HTML 5 currently...
    # ... and it's not working very well. Several required show up as valid even when blank
    if $('#payment_form')[0].checkValidity() == false
      $('#payment_form input, #payment_form select').each ->
        if $(this)[0].checkValidity() == false
          $(this).closest('.form-group').addClass('has-error')
