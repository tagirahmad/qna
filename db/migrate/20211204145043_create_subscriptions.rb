class CreateSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.references :subscribeable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
