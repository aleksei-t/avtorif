class AddExternalIdColnumToImportJobs < ActiveRecord::Migration
  def self.up
    add_column :import_jobs, :external_id_colnum, :integer
  end

  def self.down
    remove_column :import_jobs, :external_id_colnum
  end
end
