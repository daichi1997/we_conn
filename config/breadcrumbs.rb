crumb :root do
  link "トップページ", root_path
end

crumb :EventHome do
  link "イベント共有一覧", events_path
  parent :root
end

crumb :MatchingRecord do
  link "マッチング履歴", matches_path
  parent :EventHome
end

crumb :ChatRoom do
  link "チャットルーム", event_chat_room_path
  parent :MatchingRecord
end

crumb :EventShow do
  link "イベント詳細ページ", event_path
  parent :EventHome
end
crumb :EventEdit do
  link "イベント編集ページ", edit_event_path
  parent :EventShow
end

crumb :UserShow do
  link "ユーザー詳細ページ", user_path
  parent :EventHome
end

crumb :UserEdit do
  link "ユーザー編集ページ", edit_user_path
  parent :UserShow
end

crumb :NewEvent do
  link "新規投稿画面", new_event_step_path(:basic_info)
  parent :EventHome
end

crumb :DateLocation do
  link "日時・場所指定", new_event_step_path(:date_and_location)
  parent :NewEvent
end

crumb :ImageUpload do
  link "画像アップロード", new_event_step_path(:image_upload)
  parent :DateLocation
end

crumb :Confirmation do
  link "最終確認", new_event_step_path(:confirmation)
  parent :ImageUpload
end


