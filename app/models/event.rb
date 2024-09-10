class Event < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :tag
  belongs_to :tag
  belongs_to :user, optional: true
  belongs_to_active_hash :month
  belongs_to_active_hash :day

  has_one_attached :image
  has_many :likes
  has_many :comments, dependent: :destroy
  has_one :chat_room, dependent: :destroy

  validates :title, :description, presence: true, if: :validating_basic_info?
  validates :start_time, :location, presence: true, if: :validating_date_and_location?
  validates :tag_id, presence: true, if: :validating_basic_info?

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

  def image_attached?
    image.attached?
  end

  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end

  scope :by_month_and_day, lambda { |month, day|
    where('EXTRACT(MONTH FROM DATE(start_time)) = ? AND EXTRACT(DAY FROM DATE(start_time)) = ?', month, day)
  }

  scope :with_details, -> { includes(:user, image_attachment: :blob) }

  scope :with_image, -> { includes(image_attachment: :blob) }

  # 日付のみを返すメソッド
  def start_date
    start_time.to_date
  end

  def likes_count
    self[:likes_count] || likes.count
  end

  private

  def image_type
    return unless image.attached?

    return if image.content_type.in?(%w[image/jpeg image/png])

    errors.add(:image, 'must be a JPEG or PNG')
  end
end
