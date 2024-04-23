class Comment < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :blog_post
  belongs_to :user

  scope :desc_order, -> { order(created_at: :desc) }

  after_create_commit { broadcast_prepend_to [blog_post, :comments], target: "#{dom_id(blog_post)}_comments" }
end