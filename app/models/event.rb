class Event < ApplicationRecord
  belongs_to :user

  validates :title,        presence: true,
  validates :description,        presence: true,
  validates :stars_time,        presence: true,
  validates :location,        presence: true,
  validates :tag_id,        presence: true, numericality:  { other_than: 1, message: "can't be blank" }
end
