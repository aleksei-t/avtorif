class ManufacturersController < ApplicationController
  # GET /manufacturers
  # GET /manufacturers.xml
  def index
    m = Manufacturer.arel_table
    @manufacturers = Manufacturer.order(:title).where(m[:title].matches("#{params[:letter]}%")).paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @manufacturers }
    end
  end

  # GET /manufacturers/1
  # GET /manufacturers/1.xml
  def show
    @manufacturer = Manufacturer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @manufacturer }
    end
  end

  # GET /manufacturers/new
  # GET /manufacturers/new.xml
  def new
    @manufacturer = Manufacturer.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @manufacturer }
    end
  end

  # GET /manufacturers/1/edit
  def edit
    @manufacturer = Manufacturer.find(params[:id])
  end

  def edit_multiply
    if params["commit"] == "Удалить"
      Manufacturer.delete(params['manufacturer_ids'])
      cookies.delete :multiply_ids
      redirect_to(manufacturers_path(:page => params[:page], :letter => params[:letter])) and return
    end
    
    @manufacturers = Manufacturer.find(params['manufacturer_ids'])
  end

  def update_multiply
    manufacturer_synonyms = ManufacturerSynonym.where(:manufacturer_id => params[:manufacturer_ids])
    manufacturer_synonyms.each do |ms|
      ms.update_attributes!(params[:manufacturer])
    end

    Manufacturer.delete(params[:manufacturer_ids])
    cookies.delete :multiply_ids
    redirect_to(manufacturers_path(:page => params[:page], :letter => params[:letter]))
  end

  # POST /manufacturers
  # POST /manufacturers.xml
  def create
    @manufacturer = Manufacturer.new(params[:manufacturer])

    respond_to do |format|
      if @manufacturer.save
        format.html { redirect_to(@manufacturer, :notice => 'Manufacturer was successfully created.') }
        format.xml  { render :xml => @manufacturer, :status => :created, :location => @manufacturer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @manufacturer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /manufacturers/1
  # PUT /manufacturers/1.xml
  def update
    @manufacturer = Manufacturer.find(params[:id])

    respond_to do |format|
      if @manufacturer.update_attributes(params[:manufacturer])
        format.html { redirect_to(@manufacturer, :notice => 'Manufacturer was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @manufacturer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /manufacturers/1
  # DELETE /manufacturers/1.xml
  def destroy
    @manufacturer = Manufacturer.find(params[:id])
    @manufacturer.destroy

    respond_to do |format|
      format.html { redirect_to(manufacturers_path(:page => params[:page], :letter => params[:letter])) }
      format.xml  { head :ok }
      format.js { render :text => "Заглушка" }
    end
  end
end
