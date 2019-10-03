class CreateAuctions < ActiveRecord::Migration[6.0]
  def change
    create_table :auctions do |t|
      t.string :name, null: false
      t.string :description
      t.string :picture
      t.float :bid, null: false
      t.date :end_date, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
