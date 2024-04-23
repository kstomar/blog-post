class Comment < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :blog_post
  belongs_to :user

  scope :desc_order, -> { order(created_at: :desc) }

  after_destroy_commit { broadcast_remove_to [blog_post, :comments], target: "#{dom_id(self)}" }
end