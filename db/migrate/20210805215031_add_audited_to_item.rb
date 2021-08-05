class AddAuditedToItem < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :audited, :boolean
  end
end
