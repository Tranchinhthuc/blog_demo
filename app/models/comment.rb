class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :entry
  default_scope -> { order(created_at: :asc) }
  #validates :user_id, presence: true
  #validates :entries_id, presence: true
  validates :content, presence: true, length: { maximum: 1400 }
end
