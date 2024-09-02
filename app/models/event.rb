class Event < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :tag
  belongs_to  :tag
  belongs_to :user
  has_one_attached :image


  validates :title, :description, presence: true, if: :validating_basic_info?
  validates :start_time, :location, presence: true, if: :validating_date_and_location?
  validates :tag_id, presence: true

  attr_accessor :current_step

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "location", "start_time", "tag_id", "title", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user", "tag"]  
  end

  def validating_basic_info?
    current_step == 'basic_info'
  end

  def validating_date_and_location?
    current_step == 'date_and_location'
  end

  def validating_image_upload?
    current_step == 'image_upload'
  end

  def image_attached?
    image.attached?
  end

  private

  def image_type
    return unless image.attached?

    return if image.content_type.in?(%w[image/jpeg image/png])

    errors.add(:image, 'must be a JPEG or PNG')
  end
end
