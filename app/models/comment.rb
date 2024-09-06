class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :event
  validates :content, presence: true

  def toggle_owner_like!
    update(liked_by_owner: !liked_by_owner)
  end
end
