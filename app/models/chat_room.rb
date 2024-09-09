class ChatRoom < ApplicationRecord
  belongs_to :event
  has_many :messages
  belongs_to :user
end
