class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.integer :user_id
      t.text :title
      t.text :body

      t.timestamps
    end
    add_index :articles, :user_id
  end
end
