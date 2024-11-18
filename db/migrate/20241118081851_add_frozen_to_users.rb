class AddFrozenToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :frozen, :boolean
  end
end
