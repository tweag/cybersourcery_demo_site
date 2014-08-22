class MerchantDataSerializer
  attr_reader :start_count

  def initialize(start_count = 1)
    @start_count = start_count
  end

  def serialize(merchant_data)
    scanned_data = merchant_data.to_json.scan(/.{1,100}/)
    serialized_data = {}

    scanned_data.each_with_index do |item, index|
      count = index + @start_count

      if count < 1 || count > 98
        raise Exceptions::CybersourceryError, "The supported merchant_defined_data range is 1 to 98. #{count} is out of range."
      end

      serialized_data["merchant_defined_data#{count}".to_sym] = item
    end

    serialized_data
  end

  def deserialize(params)
    JSON.parse(params.select { |k,v| k =~ /^merchant_defined_data/ }.values.join).symbolize_keys
  end
end
