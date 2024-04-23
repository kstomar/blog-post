class AddIsDraftToBlogs < ActiveRecord::Migration[7.1]
  def change
    add_column :blogs, :is_draft, :boolean, default: false
  end
end
