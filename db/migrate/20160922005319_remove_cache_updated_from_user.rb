class RemoveCacheUpdatedFromUser < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :cache_updated
  end
end
