  class Pop3Receiver

  def self.receive(receiver)
    @receiver = receiver

    if @receiver.ssl?
      Net::POP3.enable_ssl(OpenSSL::SSL::VERIFY_NONE)
    else
      Net::POP3.disable_ssl
    end
    
    pop = Net::POP3.start(@receiver.server, @receiver.port, @receiver.login, @receiver.password)
    begin
      # pop.set_debug_output $stderr
      pop.mails.reverse.each_with_index do |email, index|
        unless index > AppConfig.max_emails

          net_popmail = email.pop

          email_id = @receiver.login + " - " + @receiver.server + ":" + @receiver.port
          tempfile = File.open(Rails.root.to_s + '/public/system/emails/' + email_id + ' - ' + Time.zone.now.to_s, 'w')
            tempfile.write net_popmail
          tempfile.close

          mail = Notifier.receive(net_popmail)

          !mail.attachments.nil? && mail.attachments.each do |attachment|
            md5 =  Digest::MD5.hexdigest(attachment.string)

            if Attachment.find(:first, :conditions => ['md5 = ? AND supplier_id = ? AND attachment_file_name = ?',  md5, @receiver.receive_job.job.supplier.id, attachment.original_filename]).nil?

              attachment = Attachment.new(:attachment => attachment, :md5 => md5, :email_id => File.basename(tempfile.path))
              attachment.supplier = @receiver.receive_job.job.supplier
              attachment.save

              @receiver.receive_job.job.childs.each do |child|
                JobWalker.new.start_job(child, attachment.id)
              end

            end
          end
        end
        email.delete
      end
    ensure
      pop.finish
    end
  end
end
