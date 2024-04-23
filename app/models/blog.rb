class Blog < ApplicationRecord
  validates :title, :content, presence: true

  belongs_to :user
  has_many :comments, dependent: :destroy

  scope :desc_order, -> { order(created_at: :desc) }

  self.per_page = 3

  after_create :update_publication_at


  has_rich_text :content

  private

  def update_publication_at
    update_column(:publication_at, DateTime.current)
  end
end
