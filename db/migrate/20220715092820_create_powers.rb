class CreatePowers < ActiveRecord::Migration
  def change
    create_table :powers do |t|
      t.references :campaign, index: true

      t.references :from, polymorphic: true, index: true
      t.references :to, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
