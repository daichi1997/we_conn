
# アプリケーション名
We_conn  

## アプリケーション概要
 ＜Wanna go Event connect＞<br>
 イベントを共有して一緒に参加してくれる人を探そう<br>
 投稿者と閲覧者で違う性質のいいねボタンを取り入れた革新的なマッチングシステム。



### URL
https://we-conn.onrender.com/

### テスト用アカウント
mail_address: test@test.com <br>

password:    aaa111        
  
### basic認証
id:        admin  <br>
passwarod: 2222 

### 利用方法
ゲストユーザー：イベントの一覧ページ、詳細ページの閲覧、ユーザー詳細ページの閲覧のみ。

ログインユーザー：

ユーザー管理機能

新規イベント投稿（編集と削除が可能です。）

イベント詳細ページでの”行きたい”ボタン（いいね機能）


イベント詳細ページで"行きたいボタン"押下時にコメントが投稿できます。

つけたコメントに投稿者からいいねが返ってくると"matching"ボタンからチャットルームへ遷移できます。（ナビゲーションバーのマッチング履歴からも遷移することができます。）

一覧ページの"フリーワード検索"はイベント概要欄から１文字でもヒットすれば表示され
ます。

また、日付からの検索も可能です。

タグからイベントを探すことも可能です。

一覧ページのタイトルから投稿詳細画面に遷移できます。

投稿されたURLのリンクをプレビュー窓に貼付して"プレビューを押していただくとそのURL先の要約が閲覧可能です。

ユーザー詳細ページからは画像が投稿されていれば画像から投稿詳細ページへ遷移できます。

チャットルームではマッチング同士の参加しているメンバーが表示され、そのメンバーのみ入室権限のあるチャットができます。

### アプリケーションを作成した背景

ペルソナ：自身 交友関係が広くない人,アクティブな20～40代男女

面白そうなイベントを見つけても友達と予定が合わなかったり、誘う人がいなくて一人でいくのもなぁというときにこんなサイトがあったら便利だなと思ったことから。

また、直近で予定が何に見ない日などに時間を持て余すのがいやだなと思ったときにここから面白そうなイベントを見つけて参加できるかもしれない。というのは面白そうとおもってマッチング形式にしました。

### 実装機能の画像やGIF<br>
  ![readme用](https://github.com/user-attachments/assets/145a9b16-8d8a-4a75-92e3-3b0012c5d61e)

  
![d1c473db0f80a8db5086c89d8c13c578](https://github.com/user-attachments/assets/a5759049-e0e8-42eb-8e27-bfa0b4a2873b)

 
  
 # データベース設計  
![we_conn](https://github.com/user-attachments/assets/bd8cfe70-b93b-48a3-a12f-f4dcd901b61b)

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
![webtree](https://github.com/user-attachments/assets/f3a959c6-d3e0-4938-bb52-a3e1690d8850)


## 開発環境
・フロントエンド
 HTML/CSS,Javascript
・バックエンド
 Ruby on Rails
 Javascript

.テキストエディタ
Visual Studio Code
## ローカルでの動作方法
・以下のコマンドを順に実行
% git clone
% bundle install
% rails db:create
% rails db:migrate

## 工夫したポイント
 ユーザー詳細ページで、投稿者のいいねボタン、閲覧者のいいねボタン、というそれぞれ役割の違う単独んおいいねボタンを設置して、そのいいねがマッチングした時にはじめてチャットルームに入ることができる、という点。

 権限のないユーザーはチャットルームに入ることは不可能にした点

タグによるユーザーエクスペリエンスの向上

 タイトルやキーワード検索に加え日付からの検索も可能にした点

 ユーザー投稿ページは投稿項目を3段階式にして最終確認ページでは入力してきたものを一覧で見れるのでミスが起こりにくいようにした点

ヘッダーとフッターのナビゲーションバー以外にもページ上部にパンくずリストを設置
、ページ下部にはページネーションを設置することで画面の遷移が容易に行えるという点。

ユーザー詳細ページには過去の投稿が反映され、そこからイベント詳細ページにも遷移できる点

画像アップロード時、画像を選んだ時点でプレビューが表示される点

一覧画面で、投稿されたURLから直接そのページにとばなくてもURLプレビューフォームにコピー＆ペーストするとそのページの要約がみれる点（閲覧者が不審なサイトにアクセスせずにせむ）
 
 
## 改善点

タイトルからURLフォームにかけて少し見づらいのでもう少しみやすいように考えたい
## 製作時間
8/16～
## 実装予定の機能

チャットルームの非同期化（現在は送信からリダイレクトする形）
コメントいいねの非同期化
google mapを入れ込む（API設定）
SNS連携

等を予定しております！




