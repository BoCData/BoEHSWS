class CreateDataVariables < ActiveRecord::Migration
  def change
    create_table :data_variables do |t|
      t.string :name
      t.text :description
      t.text :notes
      t.timestamps
    end
  end
end
