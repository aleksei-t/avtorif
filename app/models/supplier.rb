class Supplier < ActiveRecord::Base
  has_many :jobs
  validates_length_of :inn, :maximum=>12
  validates_length_of :kpp, :maximum=>9
end
