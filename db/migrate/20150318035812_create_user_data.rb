class CreateUserData < ActiveRecord::Migration
  def change
    create_table :user_data do |t|
      t.references :data_variable
      t.integer :user_id
      t.integer :year
      t.decimal :error_percent
      t.decimal :error
      t.string :value_string
      t.decimal :value_number_low
      t.decimal :value_number_high
      t.decimal :value_number_mid
      t.string :unit
      t.timestamps
    end
  end
end
