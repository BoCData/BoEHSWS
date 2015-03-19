class CreateLorenzData < ActiveRecord::Migration
  def change
    create_table :lorenz_data do |t|
      t.decimal :x_value, :precision => 3, :scale => 2 
      t.decimal :y_value, :precision => 7, :scale => 5 
      t.decimal :st_dev, :precision => 7, :scale => 5 
      t.references :data_variable
      t.integer :group_size
      t.integer :year
      t.timestamps null: false
    end
  end
end
