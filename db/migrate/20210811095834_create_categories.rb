#migration create categories
class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.integer :parent_id
      t.string :title
      t.string :alias
      t.text :url
      t.text :text
      t.text :text_html

      t.timestamps
    end
  end
end
