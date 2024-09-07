class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :likes
  has_many :events
  has_many :comments, dependent: :destroy
  has_many :chat_rooms


  validates :name, presence: true, length: { minimum: 2, maximum: 10 }
  validates :password, presence: true,
                       length: { minimum: 6, message: 'は6文字以上で入力してください' },
                       format: { with: /\A[a-zA-Z0-9]+\z/ },
                       if: :password_required?
  validates :bio, length: { maximum: 300 }

  def update_without_password(params, *options)
    params.delete(:password)
    params.delete(:password_confirmation)

    result = update(params, *options)
    clean_up_passwords
    result
  end

  def matched_events
    Event.joins(:comments)
         .where(comments: { user_id: self.id, liked_by_owner: true })
         .or(Event.where(user_id: self.id)
                  .joins(:comments)
                  .where(comments: { liked_by_owner: true }))
         .distinct
  end

  def password_required?
    new_record? || password.present? || password_confirmation.present?
  end

  
end
