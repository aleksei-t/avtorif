class AddTitleEnColnumToImportJob < ActiveRecord::Migration
  def self.up
    add_column :import_jobs, :title_en_colnum, :integer
  end

  def self.down
    remove_column :import_jobs, :title_en_colnum
  end
end
