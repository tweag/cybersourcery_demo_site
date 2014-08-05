class AddReturnUrlAndTransactionTypeToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :return_url, :string
    add_column :profiles, :transaction_type, :string
  end
end
