class ReceiveJobsController < ApplicationController
  # GET /receive_jobs
  # GET /receive_jobs.xml
  def index
    @receive_jobs = ReceiveJob.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @receive_jobs }
    end
  end

  # GET /receive_jobs/1
  # GET /receive_jobs/1.xml
  def show
    @receive_job = ReceiveJob.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @receive_job }
    end
  end

  # GET /receive_jobs/new
  # GET /receive_jobs/new.xml
  def new
    @receive_job = ReceiveJob.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @receive_job }
    end
  end

  # GET /receive_jobs/1/edit
  def edit
    @receive_job = ReceiveJob.find(params[:id])
  end

  # POST /receive_jobs
  # POST /receive_jobs.xml
  def create
    @receive_job = ReceiveJob.find(:first, :conditions => ["receiveable_id = ?", params[:receive_job][:receiveable_id]])

    job = Job.find(params[:job_id])
    job.jobable = @receive_job
    job.save

    respond_to do |format|
      if Job.find(params[:job_id]).jobable = @receive_job
        format.html { redirect_to(supplier_jobs_path(params[:supplier_id]), :notice => 'ReceiveJob was successfully joined.') }
        format.xml  { render :xml => @receive_job, :status => :created, :location => @receive_job }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @receive_job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /receive_jobs/1
  # PUT /receive_jobs/1.xml
  def update
    @receive_job = ReceiveJob.find(:first, :conditions => ["receiveable_id = ?", params[:receive_job][:receiveable_id]])

    job = Job.find(params[:job_id])
    job.jobable = @receive_job
    job.save


    respond_to do |format|
      if @receive_job.update_attributes(params[:receive_job])
        format.html { redirect_to(supplier_jobs_path(params[:supplier_id]), :notice => 'ReceiveJob was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @receive_job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /receive_jobs/1
  # DELETE /receive_jobs/1.xml
  def destroy
    @receive_job = ReceiveJob.find(params[:id])
    @receive_job.destroy

    respond_to do |format|
      format.html { redirect_to(receive_jobs_url) }
      format.xml  { head :ok }
    end
  end
end
