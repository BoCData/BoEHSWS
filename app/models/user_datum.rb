class UserDatum < ActiveRecord::Base
  belongs_to :data_variable_value, dependent: :destroy
end
