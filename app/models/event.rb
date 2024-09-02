class Event < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :title, :description, presence: true, if: :validating_basic_info?
  validates :start_time, :location, presence: true, if: :validating_date_and_location?

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
