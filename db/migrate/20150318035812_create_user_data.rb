class CreateUserData < ActiveRecord::Migration
  def change
    create_table :user_data do |t|
      t.references :data_variable_value
      t.integer :user_id
      t.string :value
      t.timestamps
    end
  end
end
