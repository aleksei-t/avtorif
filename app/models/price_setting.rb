class PriceSetting < ActiveRecord::Base
  has_many :import_jobs
  belongs_to :import_job
  belongs_to :supplier

  belongs_to :currency_buy, :class_name => 'Currency'
  validates_presence_of :currency_buy
  validates_presence_of :delivery_summary

  belongs_to :currency_weight, :class_name => 'Currency'
  validates_presence_of :currency_weight
  validates :success_percent, :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 100, :allow_nil => false, :only_integer => true}
  validates :minimal_retail_rate_for_price, :numericality => {:greater_than => 1}
  validates :discount_rate_for_price, :numericality => {:less_than_or_equal_to => 1}
  validates_numericality_of :retail_rate, :greater_than => 0, :less_than => 1000
  validates_numericality_of :absolute_buy_rate, :greater_than_or_equal_to => 0, :less_than => 1000
  validates_numericality_of :relative_buy_rate, :greater_than => 0, :less_than => 1000
  validates_numericality_of :absolute_weight_rate, :greater_than_or_equal_to => 0, :less_than => 1000
  validates_numericality_of :relative_weight_rate, :greater_than_or_equal_to => 0, :less_than => 1000
  validates_numericality_of :kilo_price, :greater_than_or_equal_to => 0, :less_than => 1000, :allow_nil => true
  validates_numericality_of :weight_unavailable_rate, :greater_than_or_equal_to => 0, :less_than => 1000, :allow_nil => true
  validates_numericality_of :kilo_price, :greater_than_or_equal_to => 0, :less_than => 1000  
  validates_numericality_of :weight_unavailable_rate, :greater_than_or_equal_to => 0, :less_than => 1000

end
