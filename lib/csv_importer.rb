class CsvImporter < AbstractImporter

  def import

    attachments = Attachment.all(:conditions => ['id = ? AND supplier_id = ?', @optional, @importer.import_job.job.supplier.id])
    #@importer.import_job.job.supplier
    #file
    attachments.each do |attachment|
      counter = 0
      # require 'csv'
      #begin
      #require 'csvscan'

      file = File.new(attachment.attachment.path, 'r')
      #CSVScan.scan(File.open(attachment.attachment.path, 'r')) do |columns|
      #Excelsior::Reader.rows(File.open(attachment.attachment.path, 'rb')) do |columns|
        #Ccsv.foreach(attachment.attachment.path) do |columns|
        #FasterCSV.foreach(attachment.attachment.path, :col_sep => @importer.delimeter.to_i) do |columns|
        #CSV.open(attachment.attachment.path, 'r', @importer.delimeter.to_i) do |columns|

        # очищаем price
        @importer.import_job.job.prices.clear

        file.each_line("\n") do |row|
          unless row.empty?
            columns = row.split(@importer.delimeter.to_i.chr)
          else
            next
          end

          #if columns.size != 5
          #  i = 42
          #end
          
          counter += 1

          next if columns.empty?
          next if counter < @importer.start_from_line

            require 'iconv'
            iconv = Iconv.new("utf-8", "windows-1251")

            manufacturer = Manufacturer.find_or_create_by_title(iconv.iconv(columns[@importer.import_job.manufacturer_colnum - 1]))
            goods = Goods.find(:first, :conditions => ['catalog_number = ? and manufacturer_id = ?', columns[@importer.import_job.catalog_number_colnum - 1], manufacturer])

            initial_cost = iconv.iconv(columns[@importer.import_job.cost_colnum - 1])
            initial_cost = initial_cost.gsub(',', '.')
            initial_cost = initial_cost.to_f
            result_cost = initial_cost * @importer.import_job.margin.to_f


            if goods.nil?

              goods = Goods.create(:title => iconv.iconv(columns[@importer.import_job.title_colnum - 1]),
                :catalog_number => iconv.iconv(columns[@importer.import_job.catalog_number_colnum - 1]),
                :manufacturer => manufacturer
              )
              # TODO сделать
              # оригинал
              # TODO сделать
              # t.integer :replacement_colnum
            end

            Price.create(
              :goods => goods,
              :supplier => @importer.import_job.job.supplier.title,
              :title => iconv.iconv(columns[@importer.import_job.title_colnum - 1]),
              :initial_cost => initial_cost,
              :result_cost => result_cost,
              :margin => @importer.import_job.margin.to_f,
              :count => iconv.iconv(columns[@importer.import_job.count_colnum - 1]),
              :manufacturer => manufacturer.title,
              :catalog_number => iconv.iconv(columns[@importer.import_job.catalog_number_colnum - 1]),
              :import_rule => @importer.import_job.job.title,
              :job => @importer.import_job.job
            )

            # TODO настройки для csv файла: разделитель
            # с какой строки начать парсить
            #break if file.lineno > 10
        end
      #rescue Exception => e
      #  retry
      #end
    end
  end
end
#end