class ChatRoom < ApplicationRecord
  belongs_to :event
  has_many :messages
end
