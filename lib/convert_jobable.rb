class ConvertJobable < AbstractJobber

  def perform
    #unpack_class = (@jobable.receiveable.type.to_s.split(/Receive/).first + "Receiver").classify.constantize
    #receiver = receiver_class.new(@job, @jobable, @jobable.receiveable, @optional)
    #self.optional = receiver.receive

    retval = Array.new()
    supplier_price = SupplierPrice.find(@optional).attachment

    #puts @jobable.convert_method
    case @jobable.convert_method.to_s
      when /_csv_encode_/
        remote_file = RemoteFile.new(supplier_price.path)

        encode(@jobable.encoding, supplier_price.path.shellescape, remote_file.path.shellescape)


        md5 = Digest::MD5.file(remote_file.path).hexdigest
        wc_stat = `wc #{remote_file.path.to_s.shellescape}`

        remote_file.original_filename = File.basename(supplier_price.original_filename)

        attachment = SupplierPrice.new(:attachment => remote_file, :md5 => md5, :wc_stat => wc_stat)
        attachment.supplier = @job.supplier
        attachment.job_code = @job.job_code
        attachment.job_id = @job.id
        attachment.save

        retval << attachment.id

        remote_file.unlink
        
      when /csv_normalize_new_line/
          #puts supplier_price.original_filename
          remote_file = RemoteFile.new(supplier_price.path)
          remote_file2 = RemoteFile.new(supplier_price.path)

          file = File.new(supplier_price.path, 'r')
          file.each_line("\n") do |row|
            row.gsub!("\"", "")
            unless row.empty?
                remote_file.write(row.split(eval("\"#{@jobable.col_sep.to_s}\"")).collect(&:strip).to_csv )
            else
              next
            end
          end

          # wanna street magic?
          # source_encoding = `enca -L ru #{remote_file.path.shellescape} -i`
          # suxx
          remote_file.flush
          remote_file2.flush
          
          encode(@jobable.encoding, remote_file.path.shellescape, remote_file2.path.shellescape)

          md5 = Digest::MD5.file(remote_file2.path).hexdigest
          wc_stat = `wc #{remote_file2.path.to_s.shellescape}`

          remote_file2.original_filename = File.basename(supplier_price.original_filename)

          attachment = SupplierPrice.new(:attachment => remote_file2, :md5 => md5, :wc_stat => wc_stat)
          attachment.supplier = @job.supplier
          attachment.job_code = @job.job_code
          attachment.job_id = @job.id
          attachment.save

          retval << attachment.id

          remote_file.unlink
          remote_file2.unlink
        
      when /xls_roo/

        s = Excel.new(supplier_price.path)
        s.sheets.each do |sheet|
          remote_file = RemoteFile.new(sheet)
          s.default_sheet = sheet
          s.to_csv(remote_file.path)
          md5 = Digest::MD5.file(remote_file.path).hexdigest
          wc_stat = `wc #{remote_file.path.to_s.shellescape}`

          remote_file.original_filename = sheet

          attachment = SupplierPrice.new(:attachment => remote_file, :md5 => md5, :wc_stat => wc_stat)
          attachment.supplier = @job.supplier
          attachment.job_code = @job.job_code
          attachment.job_id = @job.id
          attachment.save

          retval << attachment.id

          remote_file.unlink
        end
      when /xls_console/

        remote_file = RemoteFile.new(supplier_price.path)

        `xls2csv -q3 #{supplier_price.path.shellescape} > #{remote_file.path.shellescape}`
        md5 = Digest::MD5.file(remote_file.path).hexdigest
        wc_stat = `wc #{remote_file.path.to_s.shellescape}`

        remote_file.original_filename = File.basename(remote_file.original_filename, File.extname(remote_file.original_filename))

        attachment = SupplierPrice.new(:attachment => remote_file, :md5 => md5, :wc_stat => wc_stat)
        attachment.supplier = @job.supplier
        attachment.job_code = @job.job_code
        attachment.job_id = @job.id
        attachment.save

        retval << attachment.id

        remote_file.unlink

      when /mdb_console/

        a = `mdb-tables #{supplier_price.path.shellescape}`
        a.split(' ').each do |table|
          remote_file = RemoteFile.new(table)
          `mdb-export #{supplier_price.path.shellescape} #{table.shellescape} > #{remote_file.path.shellescape}`
          remote_file.original_filename = table
          md5 = Digest::MD5.file(remote_file.path).hexdigest
          wc_stat = `wc #{remote_file.path.to_s.shellescape}`

          attachment = SupplierPrice.new(:attachment => remote_file, :md5 => md5, :wc_stat => wc_stat)
          attachment.supplier = @job.supplier
          attachment.job_code = @job.job_code
          attachment.job_id = @job.id
          attachment.save

          retval << attachment.id
          remote_file.unlink
          
        end
        
      else
        raise 'Unknown convert method'
    end

    self.optional = retval
    super

  end

  private

  def encode(encoding, source, destination)
    `iconv -f #{encoding} -t utf-8 #{source} > #{destination}`
    if $?.to_i != 0
      raise 'Ошибка перекодирования в iconv вероятно входная кодировка выставлена неверно, id задачи ' + @job.id.to_s
    end
  end
end