class CreateDataVariableValues < ActiveRecord::Migration
  def change
    create_table :data_variable_values do |t|
      t.references :data_variable, index: true
      t.string :value
      t.timestamps
    end
  end
end
