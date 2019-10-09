class ChangeAmountToBeDecimalInBids < ActiveRecord::Migration[6.0]
  def change
    change_column :bids, :amount, :decimal, precision: 9, scale: 2, null: false
  end
end
