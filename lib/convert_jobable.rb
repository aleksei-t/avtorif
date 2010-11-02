class ConvertJobable < AbstractJobber
  def perform
    #unpack_class = (@jobable.receiveable.type.to_s.split(/Receive/).first + "Receiver").classify.constantize
    #receiver = receiver_class.new(@job, @jobable, @jobable.receiveable, @optional)
    #self.optional = receiver.receive

    retval = Array.new()
    supplier_price = SupplierPrice.find(@optional).attachment

    case File.extname(supplier_price.path).sub('.', '')

      when 'xls'

          s = Excel.new(supplier_price.path)
          s.sheets.each do |sheet|
          remote_file = RemoteFile.new(sheet)
          s.default_sheet = sheet
          s.to_csv(remote_file.path)
          md5 = Digest::MD5.file(remote_file.path).hexdigest
          remote_file.original_filename = sheet

          attachment = SupplierPrice.new(:attachment => remote_file, :md5 => md5)
          attachment.supplier = @job.supplier
          attachment.job_code = @job.job_code
          attachment.job_id = @job.id
          attachment.save

          retval << attachment.id

          remote_file.unlink


=begin
+  def perform
        +    #unpack_class = (@jobable.receiveable.type.to_s.split(/Receive/).first + "Receiver").classify.constantize
        +    #receiver = receiver_class.new(@job, @jobable, @jobable.receiveable, @optional)
        +    #self.optional = receiver.receive
        +
        +    retval = Array.new()
        +    supplier_price = SupplierPrice.find(@optional).attachment
        +
        +    remote_file = RemoteFile.new(supplier_price.path)
        +
        +    `xls2csv -q2 #{supplier_price.path.shellescape} > #{remote_file.path.shellescape}`
        +    md5 = Digest::MD5.file(remote_file.path).hexdigest
        +    remote_file.original_filename = File.basename(remote_file.original_filename, File.extname(remote_file.original_filename)) + ".csv"
        +
        +    attachment = SupplierPrice.new(:attachment => remote_file, :md5 => md5)
        +    attachment.supplier = @job.supplier
        +    attachment.job_code = @job.job_code
        +    attachment.job_id = @job.id
        +    attachment.save
        +
        +    retval << attachment.id
        +
        +    remote_file.unlink
        +
        +    self.optional = retval
        +    super
        +
        +  end
        +
=end


        end

      when 'mdb'

        a = `mdb-tables #{supplier_price.path}`
        a.split(' ').each do |table|
          remote_file = RemoteFile.new(table)
          `mdb-export #{supplier_price.path} #{table} > #{remote_file.path}`
          remote_file.original_filename = table
          md5 = Digest::MD5.file(remote_file.path).hexdigest

          attachment = SupplierPrice.new(:attachment => remote_file, :md5 => md5)
          attachment.supplier = @job.supplier
          attachment.job_code = @job.job_code
          attachment.job_id = @job.id
          attachment.save

          retval << attachment.id
          remote_file.unlink
          
        end

      else
        raise 'Unknown file extension'
    end

    self.optional = retval
    super

  end

end