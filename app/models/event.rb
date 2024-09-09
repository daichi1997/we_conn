class Event < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :tag
  belongs_to :tag
  belongs_to :user, optional: true  

  has_one_attached :image
  has_many :likes
  has_many :comments, dependent: :destroy
  has_one :chat_room,dependent: :destroy

  validates :title, :description, presence: true, if: :validating_basic_info?
  validates :start_time, :location, presence: true, if: :validating_date_and_location?
  validates :tag_id, presence: true

  attr_accessor :current_step

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at description id location start_time tag_id title updated_at user_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[user tag]
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

  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end

  private

  def image_type
    return unless image.attached?

    return if image.content_type.in?(%w[image/jpeg image/png])

    errors.add(:image, 'must be a JPEG or PNG')
  end
end
