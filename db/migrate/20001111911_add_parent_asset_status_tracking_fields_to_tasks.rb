class AddParentAssetStatusTrackingFieldsToTasks < ActiveRecord::Migration
  def self.up

    add_column :tasks, :asset_status_create, :string,  { :null => true, :default => '', :limit   => 32 }
    add_column :tasks, :asset_status_update, :string,  { :null => true, :default => '', :limit   => 32 }

    add_index  :tasks, [:asset_status_create], :unique => false, :name => 'ix_tasks_asset_status_create'    
    add_index  :tasks, [:asset_status_update], :unique => false, :name => 'ix_tasks_asset_status_update'    

  end

  def self.down
    remove_index  :tasks, :ix_tasks_asset_status_create
    remove_index  :tasks, :ix_tasks_asset_status_update
    remove_column :tasks, :asset_status_create
    remove_column :tasks, :asset_status_update
  end
end
