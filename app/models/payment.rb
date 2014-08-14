class Payment
  # These are dependencies for ActiveModel::Errors in the initialize method
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Validations

  # So we can use form_for in a view
  include ActiveModel::Conversion

  attr_reader :signer, :profile, :errors
  attr_accessor :bill_to_forename, :bill_to_surname, :card_number, :card_expiry_date,
                :card_expiry_dummy, :card_expiry_month, :card_expiry_year, :card_cvn, :card_type,
                :bill_to_email, :bill_to_address_line1, :bill_to_address_line2,
                :bill_to_address_city, :bill_to_address_state, :bill_to_address_postal_code
  validates_presence_of :bill_to_forename, :bill_to_surname, :card_number, :card_expiry_date,
                        :card_expiry_dummy, :card_expiry_month, :card_expiry_year, :card_cvn,
                        :card_type, :bill_to_email, :bill_to_address_line1, :bill_to_address_city,
                        :bill_to_address_state, :bill_to_address_postal_code

  # To keep ActiveModel::Conversion happy
  def persisted?
    false
  end

  def initialize(signer, profile)
    @signer = signer
    @profile = profile
    # I'm not doing dependency injection for ActiveModel dependencies.
    # Given we're extending ActiveModel::Naming above, we're already tightly bound...
    @errors = ActiveModel::Errors.new(self)
  end

  def form_action_url
    @profile.transaction_url
  end

  def signed_form_data
    @signer.signed_form_data
  end

  def simple_form_input(form, field, value = nil, required = true)
    form.input field, label: field_label(field), input_html: { name: field.to_s, value: value }
  end

  def simple_form_select(form, field, collection, selected = nil, prompt = nil)
    form.input(
      field,
      label: field_label(field),
      collection: collection,
      selected: selected,
      prompt: prompt,
      input_html: { name: field.to_s }
    )
  end

  def hidden_input(form, field, value = nil)
    form.hidden_field field, value: value, name: field.to_s
  end

  def field_label(field)
    labels = {
      bill_to_forename: 'First Name',
      bill_to_surname: 'Last Name',
      card_number: 'Card Number',
      card_cvn: 'Security Code',
      card_expiry_dummy: 'Expiration',
      bill_to_email: 'Email',
      bill_to_address_line1: 'Street Address (line 1)',
      bill_to_address_line2: 'Street Address (line 2)',
      bill_to_address_city: 'City',
      bill_to_address_state: 'State (Province)',
      bill_to_address_postal_code: 'Zip (Postal Code)'
    }
    labels[field]
  end
end
