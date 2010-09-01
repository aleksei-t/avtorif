class Job < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 100
  has_many :prices

  has_and_belongs_to_many :repeats

  #has_one :receive, :as => :receiveable
  #has_one :import, :as => :importable

  belongs_to :supplier
  belongs_to :jobable, :polymorphic => true
  has_many :childs, :class_name => "Job", :foreign_key => "job_id"
  belongs_to :parent, :class_name => "Job", :foreign_key => "job_id"
  #has_one :child_job, :foreign_key => :job_id, :class_name => "Job"
  #belongs_to :parent_job, :readonly => true, :foreign_key => :job_id, :class_name => "Job"

  def critical?
    # Если задача еще ниразу не сработала
    if !last_start
      return true
    end

    # Если задача еще ниразу не выполнилась
    if !last_finish
      return true
    end

    # проверка на переиодичность выполнения задачи
    if DateTime.now > last_start + interval_between_jobs.days
      return true
    end

    if DateTime.now > last_finish + interval_between_jobs.days
      return true
    end

    # проверка на длительность выполнения
    if DateTime.now > last_start + interval_working.hours
      return true
    end


    
  end
=begin
  def after_save
    jw = JobWalker.new
    self.next_start = Time.now - 1
    jw.update_next_start self
    #self.save
  end
end
=end

end