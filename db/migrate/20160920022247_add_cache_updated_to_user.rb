class AddCacheUpdatedToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :cache_updated, :datetime
  end
end
