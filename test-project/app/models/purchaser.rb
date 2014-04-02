class Purchaser < ActiveRecord::Base
  has_many :orders
end
