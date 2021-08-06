class AddUserRefToLogs < ActiveRecord::Migration[6.0]
  def change
    add_reference :logs, :user, null: false, foreign_key: true
  end
end
