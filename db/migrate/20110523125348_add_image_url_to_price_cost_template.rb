class AddImageUrlToPriceCostTemplate < ActiveRecord::Migration
  def self.up
    add_column :price_cost_templates, :image_url, :string
  end

  def self.down
    remove_column :price_cost_templates, :image_url
  end
end
