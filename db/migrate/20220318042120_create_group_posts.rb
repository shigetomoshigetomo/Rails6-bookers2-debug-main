class CreateGroupPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :group_posts do |t|
      t.string :group_id
      t.string :user_id
      t.text :content

      t.timestamps
    end
  end
end
