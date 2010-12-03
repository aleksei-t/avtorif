class PricesController < ApplicationController

  def search
    # Локальная работа
    @prices = Price.where('catalog_number = ?', params[:price][:catalog_number]).includes(:supplier).includes(:job => :jobable)

    # Работа со сторонними сервисами
    if(defined?(params[:OnlyOurWS]) && params[:OnlyOurWS] == "1")
      threads = []

      # ALL4CAR
      threads << Thread.new() do
        Thread.current["prices"] = []
        Timeout.timeout(AppConfig.emex_timeout) do
          begin
            response = Net::HTTP.post_form(URI.parse('http://62.5.214.110/partnersws/Service.asmx/SearchResultOneCurrencyXml'), {
              'sPartCode' => params[:price][:catalog_number], 
              'sAuthCode' => '303190193312', 
              'iReplaces' => '1', 
              'sCurrency' => 'RUR'
            })

            doc = Nokogiri::XML(response.body)
            
            places = doc.xpath('/searchResult')

            places.children.each do |place|
              unless(place.is_a?(Nokogiri::XML::Element) && ["main", "extWH", "mainWH"].include?(place.name))
                next
              end

              place.children.each do |part|
                if part.blank?
                  next
                end
                
                p = Price.new

                p.supplier = Supplier.new(
                  :title => 'a4c', 
                  :inn => 7733732181, 
                  :kpp => 773301001)

                p.job = Job.new(:title => "ws")

                p.job.jobable = ImportJob.new(
                  :income_rate => 1, 
                  :retail_rate => 1.55)

                part.children.each do |option|
                  if option.blank?
                    next
                  end
                  
                  value = CGI.unescapeHTML(option.children.to_s)

                  if option.keys.size > 0
                    option.keys.each do |key|
                      p[(option.name.underscore + "_" + key.underscore + "_a4c").to_sym] = option[key].strip
                    end
                  end
                  p[(option.name.underscore + "_a4c").to_sym] = value.strip

                  case option.name
                    when /^descr$/
                      p[:title] = value.strip
                    when /^price$/
                      p[:initial_cost] = value.strip
                      p[:result_cost] = value.strip
                    when /^code$/
                      p[:catalog_number] = value.strip
                  end

                end

                Thread.current["prices"] << p

              end
            end
            rescue Exception => e
          end
        end
      end

      #EMEX
      threads << Thread.new() do

        Thread.current["prices"] = []
        Timeout.timeout(AppConfig.emex_timeout) do
          begin
            response = Net::HTTP.post_form(URI.parse('http://ws.emex.ru/EmExService.asmx/FindDetailAdv'), {
              'login'=>AppConfig.emex_login,
              'password'=> AppConfig.emex_password,
              'makeLogo' => 'true',
              'detailNum' => params[:price][:catalog_number],
              'findSubstitutes' => 'true'
            })

            doc = Nokogiri::XML(response.body)

            detail_items = doc.children.children
            detail_items.each do |z|

              if z.blank?
                next
              end

              p = Price.new

              p.supplier = Supplier.new(
                :title => 'emex', 
                :inn => 7716542310, 
                :kpp => 771601001
              )

              p.job = Job.new(:title => "ws")

              p.job.jobable = ImportJob.new(
                :income_rate => 1, 
                :retail_rate => 1.55
              )

              z.children.children.each do |c|

                if c.blank?
                  next
                end

                value = CGI.unescapeHTML(c.children.to_s)

                case c.name
#                when /^DateChange$/
#                  p[:created_at] = value
#                  p[:updated_at] = value
                  when /^DetailNum$/
                    p[:catalog_number] = value.strip
#                 when /^QuantityText$/
#                   p[:count] = value.gsub(/[><=]/, "").to_i
                  when /^DetailNameRus$/
                    p[:title] = value.strip
                  when /^DetailNameEng$/
                    p[:title_en] = value.strip
                  when /^ResultPrice$/
                    p[:initial_cost] = value.strip
                    p[:result_cost] = value.strip
                  when /^MakeName$/
                    p[:manufacturer] = value.strip
                  when /^MakeLogo$/
                    p[:manufacturer_short] = value.strip
#                 when /^DeliverTimeGuaranteed/
#                   p[:estimate_days] = value.to_s
#                 when /^PriceDesc$/
#                   p[:supplier] = value
#                 when /^PriceLogo$/
#                   p[:job_title] = value.to_s
#                 when /^QuantityChangeDate$/
#                   p[:updated_at] = value.to_s
                  when /^Country$/
                    p[:country] = value.strip
                  else
                    p[(c.name.underscore + "_emex").to_sym] = value.strip
                end

              end
              Thread.current['prices'] << p
            end
            rescue Exception => e
          end
        end
      end
      threads.each do |t|
        t.join
        #debugger
        @prices = @prices + t["prices"]
      end
    end

    respond_to do |format|
      format.html {render :action => :index }
      format.xml  { render :xml => @prices.to_xml(:include => {:supplier => {}, :job => {:include => {:jobable => {:except => [:kilo_price]}}}})}
    end

  end

  # GET /prices
  # GET /prices.xml
  def index
    render :text => "Unavaliable"
    return

#    @prices = Price.all
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @prices }
#    end
  end

  # GET /prices/1
  # GET /prices/1.xml
  def show
    @price = Price.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @price }
    end
  end

  # GET /prices/new
  # GET /prices/new.xml
  def new
    @price = Price.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @price }
    end
  end

  # GET /prices/1/edit
  def edit
    @price = Price.find(params[:id])
  end

  # POST /prices
  # POST /prices.xml
  def create
    @price = Price.new(params[:price])

    respond_to do |format|
      if @price.save
        format.html { redirect_to(@price, :notice => 'Price was successfully created.') }
        format.xml  { render :xml => @price, :status => :created, :location => @price }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @price.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /prices/1
  # PUT /prices/1.xml
  def update
    @price = Price.find(params[:id])

    respond_to do |format|
      if @price.update_attributes(params[:price])
        format.html { redirect_to(@price, :notice => 'Price was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @price.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /prices/1
  # DELETE /prices/1.xml
  def destroy
    @price = Price.find(params[:id])
    @price.destroy

    respond_to do |format|
      format.html { redirect_to(prices_url) }
      format.xml  { head :ok }
    end
  end
end
