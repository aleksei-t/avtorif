class CreateEmailReceives < ActiveRecord::Migration
  def self.up
    create_table :email_receives do |t|
      t.string :server
      t.string :port
      #t.string :address
      t.boolean :ssl
      t.string :login
      t.string :password
      t.string :protocol
      
      t.timestamps
    end
  end

  def self.down
    drop_table :email_receives
  end
end
