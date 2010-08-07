#logger = RAILS_DEFAULT_LOGGER
#logger.level = Logger::ERROR

class AbstractJobber
  def initialize(jobber, optional = nil)
    @jobber = jobber
    @optional = optional
    @optional = optional
  end

  def perform
    job = @jobber.job
    job.last_finish = Time.zone.now
    job.locked = false
    job.save
  end

end