class AddActionToLogs < ActiveRecord::Migration[6.0]
  def change
    add_column :logs, :action, :string
  end
end
