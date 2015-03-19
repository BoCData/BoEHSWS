class UserDatum < ActiveRecord::Base
  belongs_to :data_variable, dependent: :destroy
end
