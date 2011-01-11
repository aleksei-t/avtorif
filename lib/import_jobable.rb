class ImportJobable < AbstractJobber
  def perform
    #unless @jobable.importable.blank?
    #  importer_class = (@jobable.importable.type.to_s.split(/Import/).first + "Importer").classify.constantize
    #  importer = importer_class.new(@job, @jobable, @jobable.importable, @optional)
    #  self.optional = importer.import
    #end
      case @jobable.import_method.to_s
        when /_B_/

          job_id = Price.connection.quote(@job.id)
          Price.connection.execute("DROP TABLE IF EXISTS prices_#{job_id}")
          Price.connection.execute("CREATE TABLE prices_#{job_id} like prices")

          @optional.each do |opt|
            #debugger
            i = 0
            query = ""
            unit_colnum, multiply_factor_colnum, external_id_colnum = country_colnum = applicability_colnum =  min_order_colnum = description_colnum = unit_package_colnum = title_en_colnum = title_colnum = count_colnum = manufacturer_colnum = price_colnum = catalog_number_colnum = parts_group_colnum = false

            #Price.connection.execute("DELETE FROM prices WHERE job_id = #{job_id}")

            query_template = "INSERT INTO prices_#{job_id} (job_id, title, count, price_cost, manufacturer, catalog_number, title_en, unit_package, description, min_order, applicability, country, external_id, unit, multiply_factor, parts_group) VALUES "

            if @jobable.title_colnum.present?
              title_colnum = @jobable.title_colnum - 1
            end

            if @jobable.title_en_colnum.present?
              title_en_colnum = @jobable.title_en_colnum - 1
            end

            if @jobable.unit_package_colnum.present?
              unit_package_colnum = @jobable.unit_package_colnum - 1
            end

            if @jobable.description_colnum.present?
              description_colnum = @jobable.description_colnum - 1
            end

            if @jobable.min_order_colnum.present?
              min_order_colnum = @jobable.min_order_colnum - 1
            end

            if @jobable.count_colnum.present?
              count_colnum = @jobable.count_colnum - 1
            end

            if @jobable.manufacturer_colnum.present?              
              manufacturer_colnum = @jobable.manufacturer_colnum - 1
            end

            if @jobable.applicability_colnum.present?              
              applicability_colnum = @jobable.applicability_colnum - 1
            end

            if @jobable.multiply_factor_colnum.present?
              multiply_factor_colnum = @jobable.multiply_factor_colnum - 1
            end

            if @jobable.unit_colnum.present?              
              unit_colnum = @jobable.unit_colnum - 1
            end

            if @jobable.country_colnum.present?              
              country_colnum = @jobable.country_colnum - 1
            end

            if @jobable.external_id_colnum.present?              
              external_id_colnum = @jobable.external_id_colnum - 1
            end

            if @jobable.parts_group_colnum.present?              
              parts_group_colnum = @jobable.parts_group_colnum - 1
            end

            price_colnum = @jobable.income_price_colnum - 1
            catalog_number_colnum = @jobable.catalog_number_colnum - 1

            @jobable = nil

            if manufacturer_colnum
              manufacturer_synonyms_ar = ManufacturerSynonym.joins(:manufacturer).all
              manufacturer_synonyms_hs = Hash.new
              manufacturer_synonyms_ar.each do |ms|
                manufacturer_synonyms_hs[ms.title] = ms.manufacturer.title
              end
              manufacturer_synonyms_ar = nil
            used_in_this_price = Hash.new
            end

            #BUG Проверить, на работоспособность (Потребовалось после конвертирования из Excel в csv, где были переносы \r)
            FasterCSV.foreach(SupplierPrice.find(opt).attachment.path) do |row|
              if i == 0
                query = query_template
              end
              
              if i < 100
                
                applicability = applicability_colnum ? Price.connection.quote(row[applicability_colnum].to_s.strip) : "NULL"
                external_id = external_id_colnum ? Price.connection.quote(row[external_id_colnum].to_s.strip) : "NULL"
                parts_group = parts_group_colnum ? Price.connection.quote(row[parts_group_colnum].to_s.strip) : "NULL"
                title = title_colnum ? Price.connection.quote(row[title_colnum].to_s.strip) : "NULL"
                title_en = title_en_colnum ? Price.connection.quote(row[title_en_colnum].to_s.strip) : "NULL"
                unit_package = unit_package_colnum ? Price.connection.quote(row[unit_package_colnum].to_s.strip) : "NULL"
                unit = unit_colnum ? Price.connection.quote(row[unit_colnum].to_s.strip) : "NULL"
                multiply_factor = multiply_factor_colnum ? Price.connection.quote(row[multiply_factor_colnum].to_s.strip) : "NULL"
                description = description_colnum ? Price.connection.quote(row[description_colnum].to_s.strip) : "NULL"
                country = country_colnum ? Price.connection.quote(row[country_colnum].to_s.strip) : "NULL"
                min_order = min_order_colnum ? Price.connection.quote(row[min_order_colnum].to_s.strip) : "NULL"
                count = count_colnum ? Price.connection.quote(row[count_colnum].to_s.strip) : "NULL"
                price = Price.connection.quote(row[price_colnum].to_s.gsub(',','.').gsub(' ',''))
                catalog_number = Price.connection.quote(row[catalog_number_colnum].to_s.strip)

                if manufacturer_colnum
                  # получаем значение производителя в прайсе
                  #debugger
                  synonym = row[manufacturer_colnum].to_s.mb_chars.strip.upcase
                  # если не пустой, то нашли какой-то синоним
                  if synonym != ""
                    # если встретили этот синоним в прайсе впервые
                    unless manufacturer = used_in_this_price[synonym]
                      # если не нашли в глобальной таблице соответствия синонимов и производителей
                      unless manufacturer = manufacturer_synonyms_hs[synonym]
                        # то создаем синоним и такого же производителя
                        ManufacturerSynonym.create(:title => synonym, :manufacturer => Manufacturer.create(:title => synonym))

                        manufacturer = synonym
                        manufacturer_synonyms_hs[synonym] = manufacturer
                      end
                      # обновляем, что синоним встречался в прайсе ранее из найденного в глобальной таблице, или нового созданного
                      used_in_this_price[synonym] = manufacturer
                    end
                    manufacturer = Price.connection.quote(manufacturer)
                  # если производитель в прайсе пустой, то null
                  else
                    manufacturer = "NULL"
                  end
                # если колонки производителя нет, то null
                else
                  manufacturer = "NULL"
                end

                query = query + "(#{job_id}, #{title}, #{count}, #{price}, #{manufacturer}, #{catalog_number}, #{title_en}, #{unit_package}, #{description}, #{min_order}, #{applicability}, #{country}, #{external_id}, #{unit}, #{multiply_factor}, #{parts_group}),"

                i = i + 1
              end

              if i == 100
                query.chop!
                begin
                  Price.connection.execute(query)
                rescue => e
                  #puts query
                  #debugger
                  raise e
                end
                query = ""
                i = 0
              end

            end

            #TODO Объединить с верхним (это на случай если записей меньше n)
            if query.present?
              query.chop!
              Price.connection.execute(query)
            end
          end

          query = "INSERT INTO prices (job_id, title, count, price_cost, manufacturer, catalog_number, title_en, unit_package, description, min_order, applicability, country, external_id, unit, multiply_factor, parts_group) SELECT job_id, title, count, price_cost, manufacturer, catalog_number, title_en, unit_package, description, min_order, applicability, country, external_id, unit, multiply_factor, parts_group FROM prices_#{job_id}"
          Price.connection.execute(query)

        when /_I_/
        when /_U_/
        when /_U0_/
          
      end

    super
  end
end
