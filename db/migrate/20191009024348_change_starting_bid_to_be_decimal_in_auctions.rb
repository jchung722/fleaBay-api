class ChangeStartingBidToBeDecimalInAuctions < ActiveRecord::Migration[6.0]
  def change
    change_column :auctions, :starting_bid, :decimal, precision: 9, scale: 2, null: false
  end
end
