class Blog < ApplicationRecord
  validates :title, :content, presence: true

  belongs_to :user
  has_many :comments, dependent: :destroy

  scope :latest, -> { order(created_at: :desc) }
  scope :published, -> { where(is_draft: false) }
  scope :draft, -> { where(is_draft: true) }

  self.per_page = 4

  after_create :set_publication_at

  has_rich_text :content

  private

  def set_publication_at
    update_column(:publication_at, DateTime.current)
  end
end
