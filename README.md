
# アプリケーション名
We_conn  

## アプリケーション概要
 ＜Wanna go Event connect＞<br>イベントを共有して誰かと一緒に参加しよう<br>

### URL

### テスト用アカウント
| mail_address | test@test.com |<br>

| password     | aaa111        |
  
### basic認証
| id | admin | <br>
| passwarod | 2222 |

### 利用方法

### アプリケーションを作成した背景

### 実装機能の画像やGIF<br>
  
  
 # データベース設計  

## usersテーブル

| Column             | Type    | Options     |
| ------------------ | ------  | ----------- |
| email              | string  | null: false, unique: true |
| encrypted_password | string  | null: false |
| name               | string  | null: false |
| bio                | text    |

### Association
  has_many :events
  has_many :likes
  has_many :comments
  has_many :chat_rooms
  has_many :messages
  has_one_attached :avatar

## eventsテーブル

| Column             | Type      | Options     |
| ------------------ | ------    | ----------- |
| user               | references| null: false, foreign_key: true |
| title              | string    | null: false |
| description        | text      | null: false |
| start_time         | datetime  | null: false |
| location           | string    | null: false |
| tag_id             | integer   | null: false |

 ### Association
  belongs_to :user
  has_many :likes
  has_many :comments
  has_one_attached :image
  belongs_to_active_hash :tag



## likes テーブル

| Column | Type       | Options    |
| ------ | ---------- | ---------- |
| user                | references | null: false, foreign_key: true |
| event               | references | null: false, foreign_key: true |

### Association

  belongs_to :user
  belongs_to :event

## comments テーブル

| Column             | Type      | Options     |
| ------------------ | ------    | ----------- |
| user               | references| null: false, foreign_key: true |
| event              | references| null: false, foreign_key: true |
| content            | text      | null: false |
| liked_by_owner     | boolean   | default: false |

### Association
  belongs_to :user
  belongs_to :event



## chat_roomsテーブル

| Column             | Type      | Options     |
| ------------------ | ------    | ----------- |
| event              | references| null: false, foreign_key: true |

### Association

  belongs_to :event
  has_many :messages
  belongs_to :user


## messagesテーブル

| Column             | Type      | Options     |
| ------------------ | ------    | ----------- |
| content            | text      | null: false, foreign_key: true |
| user               | references| null: false, foreign_key: true |
| chat_room          | references| null: false, foreign_key: true |


### Association

  belongs_to :user
  belongs_to :chat_room


## 画面遷移図

## 開発環境

## ローカルでの動作方法

## 工夫したポイント

## 改善点

## 製作時間

## 実装予定の機能