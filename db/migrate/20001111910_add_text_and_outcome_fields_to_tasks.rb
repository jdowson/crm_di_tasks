class AddTextAndOutcomeFieldsToTasks < ActiveRecord::Migration
  def self.up

    add_column :tasks, :description,         :string,  { :null => true, :default => '', :limit => 255 }
    add_column :tasks, :outcome_text,        :string,  { :null => true, :default => '', :limit => 255 }
    add_column :tasks, :outcome_type_id,     :integer, { :null => true, :default => nil }
    add_column :tasks, :outcome_sub_type_id, :integer, { :null => true, :default => nil }

    add_index  :tasks, [:outcome_type_id, :outcome_sub_type_id], :unique => false, :name => 'ix_tasks_outcome_type_id_sub_type_id'    

  end

  def self.down
    remove_index  :tasks, :ix_tasks_outcome_type_id_sub_type_id
    remove_column :tasks, :description
    remove_column :tasks, :outcome_text
    remove_column :tasks, :outcome_type_id
    remove_column :tasks, :outcome_sub_type_id
  end
end
