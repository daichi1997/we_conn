class Event < ApplicationRecord
  include ActiveModel::Validations
  # belongs_to :tag, optional: true
  has_one_attached :image
  belongs_to :user

  validates :title, :description, presence: true, if: :validating_basic_info?
  validates :start_time, :location, presence: true, if: :validating_date_and_location?
  validate :image_type, if: :validating_image_upload?

  # validates :tag_id,        presence: true, numericality:  { other_than: 1, message: "can't be blank" }
  attr_accessor :current_step

  def validating_basic_info?
    current_step == 'basic_info'
  end

  def validating_date_and_location?
    current_step == 'date_and_location'
  end

  def validating_image_upload?
    current_step == 'image_upload'
  end

  private

  def image_type
    if image.attached?
      unless image.content_type.in?(%w(image/jpeg image/png))
        errors.add(:image, 'must be a JPEG or PNG')
      end
    end
  end
end