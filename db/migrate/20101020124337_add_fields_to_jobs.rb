class AddFieldsToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :job_code, :string
  end

  def self.down
    remove_column :jobs, :job_code
  end
end
