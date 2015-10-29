class UserPreference < ActiveRecord::Base
  validates :optimizely_token, uniqueness: true
end
