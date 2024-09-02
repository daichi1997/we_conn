class Tag < ActiveHash::Base
  self.data = [
    { id: 1, name: 'スポーツ' },
    { id: 2, name: '音楽' },
    { id: 3, name: 'アート' },
    { id: 4, name: '料理' },
    { id: 5, name: '旅行' },
    { id: 6, name: '娯楽' },
    { id: 7, name: '芸能' },
    { id: 8, name: '学習' },
    { id: 9, name: '伝統・文化' },
    { id: 10, name: 'その他' }

    # 必要に応じてタグを追加
  ]
  include ActiveHash::Associations
  has_many :events

end


