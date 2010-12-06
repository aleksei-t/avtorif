class AddDeliverySummaryToImportJobs < ActiveRecord::Migration
  def self.up
    add_column :import_jobs, :delivery_summary, :string
  end

  def self.down
    remove_column :import_jobs, :delivery_summary
  end
end
