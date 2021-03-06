class Supplier < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  #devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :trackable, :validatable
  #
  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation
  has_many :jobs, :dependent => :destroy
  validates_length_of :inn, :maximum => 12
  validates_length_of :kpp, :maximum => 9
  #validates_presence_of :inn
  #validates_presence_of :kpp
  has_many :supplier_prices
  has_many :prices
  belongs_to :discount_group
 
  has_many :price_settings

  validate :validate_supplier

  def to_s
    title
  end

  def validate_supplier
    unless(self.inn.present? || self.phone.present?)
      errors.add(:base, "Необходимо чтобы были заполнены ИНН, ИНН и КПП, или Номер Телефона")
    end
  end

  def status
#    Job.all
#    zzz = jobs.scoped(:joins => "left join receive_jobs on receive_jobs.id = jobs.id", :conditions => {:jobable_type => 'ReceiveJob'})
#    zzz.each.map do |job|
#      SupplierPrice.find(:all, :conditions => {:job_id => job.id})
#    end
  end
end
