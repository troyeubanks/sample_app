class AddIndicesToRelationships < ActiveRecord::Migration
  def change
  	rename_column :relationships, :following_id, :followed_id
	 	add_index :relationships, :follower_id
	  add_index :relationships, :followed_id
	  add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
