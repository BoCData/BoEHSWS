class DataVariable < ActiveRecord::Base
  has_many :data_variable_values
end
