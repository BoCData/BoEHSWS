class DataVariableValue < ActiveRecord::Base
  belongs_to :data_variable, dependent: :destroy
  has_many :user_data
end
