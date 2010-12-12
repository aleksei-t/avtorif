class ImportJobable < AbstractJobber
  def perform
    #unless @jobable.importable.blank?
    #  importer_class = (@jobable.importable.type.to_s.split(/Import/).first + "Importer").classify.constantize
    #  importer = importer_class.new(@job, @jobable, @jobable.importable, @optional)
    #  self.optional = importer.import
    #end
    @optional.each do |opt|
      case @jobable.import_method.to_s
        when /_B_/
          Price.connection.execute("DELETE FROM prices WHERE job_id = #{@job.id}")
          FasterCSV.foreach(SupplierPrice.find(opt).attachment.path) do |row|
            if(@jobable.manufacturer_colnum)
              #TODO сделать какую-то реализацию нормализации производителей
            end
            p = Price.new()
            p.job_id = @job.id
            #p.job_title = @job.title
            p.goods_id = -1
            p.supplier_id = @job.supplier_id
            p.supplier = @job.supplier
            p.title = row[@jobable.title_colnum - 1].strip if @jobable.title_colnum.present? && row[@jobable.title_colnum - 1].present?
            p.count = row[@jobable.count_colnum - 1].strip if @jobable.count_colnum.present? && row[@jobable.count_colnum - 1].present?
            p.price_cost = row[@jobable.income_price_colnum - 1].to_s.strip.gsub(',','.')
            p.manufacturer = row[@jobable.manufacturer_colnum - 1].strip if @jobable.manufacturer_colnum.present? && row[@jobable.manufacturer_colnum - 1].present?
            p.catalog_number = row[@jobable.catalog_number_colnum - 1].strip if row[@jobable.catalog_number_colnum - 1].present?
            #p.inn = @job.supplier.inn
            #p.kpp = @job.supplier.kpp
            #p.estimate_days = @jobable.estimate_days
            p.save
          end
        when /_I_/
          FasterCSV.foreach(SupplierPrice.find(opt).attachment.path) do |row|
            if(@jobable.manufacturer_colnum)
              #TODO сделать какую-то реализацию нормализации производителей
            end
            p = Price.new()
            p.job_id = @job.id
            #p.job_title = @job.title
            p.goods_id = -1
            p.supplier_id = @job.supplier_id
            p.supplier = @job.supplier
            p.title = row[@jobable.title_colnum - 1].strip if @jobable.title_colnum.present? && row[@jobable.title_colnum - 1].present?
            p.count = row[@jobable.count_colnum - 1].strip if @jobable.count_colnum.present? && row[@jobable.count_colnum - 1].present?
            p.price_cost = row[@jobable.income_price_colnum - 1].to_s.strip.gsub(',','.')
            p.manufacturer = row[@jobable.manufacturer_colnum - 1].strip if @jobable.manufacturer_colnum.present? && row[@jobable.manufacturer_colnum - 1].present?
            p.catalog_number = row[@jobable.catalog_number_colnum - 1].strip if row[@jobable.catalog_number_colnum - 1].present?
            #p.inn = @job.supplier.inn
            #p.kpp = @job.supplier.kpp
            #p.estimate_days = @jobable.estimate_days
            p.save
          end
        when /_U_/

        when /_U0_/
          
      end

    end
    super
  end
end
