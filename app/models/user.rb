class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         validates :name, presence: true, length: { minimum: 2, maximum: 10 }
         validates :password, presence: true, 
         length: { minimum: 6, message: 'は6文字以上で入力してください' },
         format: { with: /\A[a-zA-Z0-9]+\z/}
         validates :email, presence: true, uniqueness: true, 
         format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }
         has_many :events
      
end
