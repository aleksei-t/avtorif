class PricesController < ApplicationController

  # Суть этой вакханалии сводится к тому, что из-за того, что в нашей базе много nil производителей, и много пересечений
  # по заменам, то мы хотим получить из таблицы только записи по каталожному номеру, а потом уже пригодится или не
  # пригодится производитель будем решать уже в памяти
  def get_from_catalog(catalog_number, manufacturer, &block)
    puts "@@@@@@@@@@@@@@@@@ " + catalog_number.to_s + " " + manufacturer.to_s + " @@@@@@@@@@@@@@@@@"
    key = catalog_number.to_s
    @private_cache ||= Hash.new
    if @private_cache.key? key
      if manufacturer
        if @private_cache[key][:with].key? manufacturer
          block.call( @private_cache[key][:with][manufacturer]) if block
          return
        end
      else
        # Все группы
        if @private_cache[key][:without].key? :catalog_number
          block.call(@private_cache[key][:without]) if block
        end
        if @private_cache[key][:with].size > 0
          @private_cache[key][:with].each_pair do |k, v|
            block.call(v) if block
          end
        end
        return
      end
    else
      md5 = Digest::MD5.hexdigest(catalog_number)[0,2]
      query = "SELECT * FROM price_catalog_#{md5} WHERE catalog_number = " + Price.connection.quote(catalog_number)
      puts "###################### #{query}  ######################"
      client = ActiveRecord::Base.connection.instance_variable_get :@connection
      result = client.query(query, :as => :hash)
      @private_cache[key] ||= {:with => {}, :without => {:catalog_number => catalog_number, :replacements => []}}
      result.each do |row|
        # Запомнили в кеше
        # hash = {
        #   "A" => { 
        #     :without => {
        #       :catalog_number, ..., :replacemnts => {
        #         {:catalog_number => "B", :manufacturer => "M1"},
        #         {:catalog_number => "B", :manufacturer => nil}
        #       }
        #     }
        #     :with => {
        #       "M1" => {:catalog_number, ... :replacements => {...}},
        #       "M2" => {:catalog_number, ... :replacements => {...}}
        #     }
        #   }
        # }

        if row['manufacturer'].blank?

          @private_cache[key][:without] = {
            :catalog_number => row['catalog_number'],
            :manufacturer => row['manufacturer'],
            :title => row['title'],
            :title_en => row['title_en'],
            :weight_grams => row['weight_grams'],
            :new_catalog_number => row['new_catalog_number'],
            :replacements => []
          }

          for i in 0...AppConfig.max_replaces
            if eval "row['r#{i}'].blank?"
              break
            else
              eval "@private_cache[key][:without][:replacements] << {
                :catalog_number => row['r#{i}'], 
                :manufacturer => row['rm#{i}']
              }"
              #if recursive
              #  get_from_catalog(row["r#{i}"], row["rm#{i}"], false, &block)
              #end
            end
          end
        else
          @private_cache[key][:with][row['manufacturer']] = {
            :catalog_number => row['catalog_number'],
            :manufacturer => row['manufacturer'],
            :title => row['title'],
            :title_en => row['title_en'],
            :weight_grams => row['weight_grams'],
            :new_catalog_number => row['new_catalog_number'],
            :replacements => []
          }
          
          for i in 0...AppConfig.max_replaces
            if eval "row['r#{i}'].blank?"
              break
            else
              eval "@private_cache[key][:with][row['manufacturer']][:replacements] << {
                :catalog_number => row['r#{i}'], 
                :manufacturer => row['rm#{i}']
              }"
              #if recursive
              #  get_from_catalog(row["r#{i}"], row["rm#{i}"], false, &block)
              #end
            end
          end
        end
      end
      # Мы запросим еще раз, чтобы на этот раз уже получить из кеша
      get_from_catalog(catalog_number, manufacturer, &block)
    end
  end

  def search

    @prices = []

    our_catalog_number = CommonModule::normalize_catalog_number(params[:catalog_number])

    if params[:manufacturer].present? && params[:manufacturer].size >= 1
      our_manufacturer = CommonModule::find_manufacturer_synonym(params[:manufacturer], -1, false)[1..-2]
    end

    replacements = []

      get_from_catalog(our_catalog_number, our_manufacturer) do |r1|
        replacements << r1
        if params[:replacements] == '1'
          r1[:replacements].each do |replacement|
            get_from_catalog(replacement[:catalog_number], replacement[:manufacturer]) do |r2|
              replacements << r2
            end
          end
        end
      end
    client = ActiveRecord::Base.connection.instance_variable_get :@connection
    query = "SELECT '1'"
    result = client.query(query, :as => :array)

    # Работа со сторонними сервисами
    if(params[:ext_ws] == '1')
      #EMEX
        Timeout.timeout(AppConfig.emex_timeout) do
          begin
            response = CommonModule::get_emex(
              :catalog_number => params[:catalog_number], 
              :manufacturer => params[:manufacturer],
              :login => AppConfig.emex_login,
              :password => AppConfig.emex_password,
              :replacements => params[:replacements]
            )

            doc = Nokogiri::XML(response)

            detail_items = doc.children.children
            detail_items.each do |z|

              if z.blank?
                next
              end

              p = Price.new
              
              p[:supplier_title] = 'emex'
              p[:supplier_title_en] = 'emex'
              p[:supplier_title_full] = 'emex'
              p[:supplier_inn] = 7716542310
              p[:supplier_kpp] = 771601001
              p[:job_title] ="ws"
              p[:job_import_job_kilo_price] = 0
              p[:job_import_job_presence] = false

              z.children.children.each do |c|

                if c.blank?
                  next
                end

                value = CGI.unescapeHTML(c.children.to_s)

                case c.name
                 when /^DestinationLogo$/
                   p[:job_import_job_delivery_summary] = (p[:job_import_job_delivery_summary].to_s + " " + value.to_s.strip).to_s.strip
                 when /^DestinationDesc$/
                   p[:job_import_job_delivery_summary] = (p[:job_import_job_delivery_summary].to_s + " " + value.to_s.strip).to_s.strip
                 when /^bitStorehouse$/
                   if(value.to_s.strip == 'true')
                     p[:job_import_job_presence] = true 
                    else
                     p[:job_import_job_presence] = false
                   end
                 when /^PriceCountry$/
                   p[:job_import_job_country_short] = value.to_s.strip
                 when /^PriceDesc$/
                   p[:job_import_job_country] = value.to_s.strip
                 when /^QuantityText$/
                   p[:count] = value.to_s.strip 
                 when /^DateChange$/
                     #p[:created_at] = DateTime.parse(value.to_s.strip)
                     #p[:updated_at] = DateTime.now
                  when /^DetailNum$/
                    p[:catalog_number] = CommonModule::normalize_catalog_number(value.to_s.strip)
                    p[:catalog_number_orig] = value.to_s.strip
                  when /^DetailNameRus$/
                    p[:title] = value.to_s.strip
                  when /^DetailNameEng$/
                    p[:title_en] = value.to_s.strip
                  when /^ResultPrice$/
                    p[:price_cost] = value.to_s.strip
                    p[:income_cost] = value.to_f * 1
                    p[:retail_cost] = p[:income_cost] * 1.55
                  when /^MakeName$/
                    p[:manufacturer] = CommonModule::find_manufacturer_synonym(value.to_s.strip, -2, true)[1..-2]
                    p[:manufacturer_orig] = value.to_s.strip
                  when /^MakeLogo$/
                    p[:manufacturer_short] = value.to_s.strip
                  when /^bitOriginal/
                    if value.to_s.strip == 'true'
                      p[:bit_original] = true
                    else
                      p[:bit_original] = false
                    end
                # TODO LOL
                 when /^ADDays$/
                    p[:job_import_job_delivery_days_declared] = value.to_s
                 when /^DeliverTimeGuaranteed$/
                    p[:job_import_job_delivery_days_average] = value.to_s
                 when /^CalcDeliveryPercent$/
                    p[:job_import_job_success_percent] = value.to_s
                    p[:success_percent] = value.to_s
                 when /^Country$/
                    p[:country] = value.to_s.strip
                 else
                    p[(c.name.underscore + "_emex").to_sym] = value.to_s.strip
                end

              end
              @prices << p
              found = false
              replacements.each do |replacement|
                if replacement[:catalog_number] == p[:catalog_number]
                  if replacement[:manufacturer] == p[:manufacturer]
                    found = true
                  end
                end
              end

              unless found
                replacements <<  { 
                  :catalog_number => p[:catalog_number],
                  :manufacturer => p[:manufacturer]
                }
              end

            end
            rescue Timeout::Error => e
          end
        end
      end

    # Локальная работа
    #@prices = Price.select("prices.*, jobs.*, import_jobs.*, suppliers.*").where('catalog_number = ?', our_catalog_number).includes(:job => {:import_job => [:currency_buy, :currency_sell, :currency_weight]}).includes(:supplier)

    replacements.each do |replacement|
      md5 = Digest::MD5.hexdigest(replacement[:catalog_number])[0,2]
      query = "
        SELECT
          p.*,
          s.title as supplier_title,
          s.title_en as supplier_title_en,
          s.title_full as supplier_title_full,
          s.inn as supplier_inn,
          s.kpp as supplier_kpp,
          j.title as job_title,
          ij.success_percent as job_import_job_success_percent,
          ij.delivery_days_average as job_import_job_delivery_days_average,
          ij.delivery_days_declared as job_import_job_delivery_days_declared,
          ij.delivery_summary as job_import_job_delivery_summary,
          ij.presence as job_import_job_presence,
          ij.kilo_price as job_import_job_kilo_price,
          ij.country as job_import_job_country,
          ij.country_short as job_import_job_country_short,
               p.price_cost * ij.income_rate AS income_cost, 
               p.price_cost * ij.income_rate * ij.retail_rate AS retail_cost, 
               CASE udr.buy_sell 
                 WHEN 0 THEN p.price_cost * ij.income_rate * udr.rate 
                 WHEN 1 THEN p.price_cost * ij.income_rate * ij.retail_rate * udr.rate 
                 ELSE p.price_cost * ij.income_rate * ij.retail_rate
               END AS result_cost 
        FROM   price_cost_#{md5} p 
               INNER JOIN jobs j 
                 ON p.job_id = j.id 
               INNER JOIN import_jobs ij 
                 ON j.jobable_id = ij.id 
               INNER JOIN suppliers s 
                ON j.supplier_id = s.id
               LEFT JOIN (SELECT dg.title, 
                                 dr.buy_sell, 
                                 dr.rate, 
                                 dr.job_id 
                          FROM   suppliers s 
                                 INNER JOIN discount_groups dg 
                                   ON dg.id = s.discount_group_id 
                                 INNER JOIN discount_rules dr 
                                   ON dr.discount_group_id = dg.id 
                          WHERE  s.id = 222198489) udr 
                 ON p.job_id = udr.job_id 
        WHERE  p.catalog_number = #{Price.connection.quote(replacement[:catalog_number])}" 
      if replacement[:manufacturer]
        query << "AND p.manufacturer = #{Price.connection.quote(replacement[:manufacturer])}"
      end
      @prices = @prices + Price.find_by_sql(query)
    end

    respond_to do |format|
      format.html {render :action => :index }
      format.xml  { render :xml => @prices.to_xml}
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
