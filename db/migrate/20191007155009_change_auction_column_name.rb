class ChangeAuctionColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :auctions, :bid, :starting_bid
  end
end
