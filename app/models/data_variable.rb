class DataVariable < ActiveRecord::Base
  has_many :data_variable_values
  has_many :user_data
end
