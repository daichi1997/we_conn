class MatchesController < ApplicationController
  before_action :authenticate_user!

  def index
    @matched_events = current_user.matched_events_with_details

    if @matched_events.empty?
      flash[:notice] = 'マッチングがありません'
      redirect_to events_path # イベント一覧ページへリダイレクト
    else
      # 最後のマッチング確認時刻を更新
      current_user.update(last_matches_check_at: Time.current)
    end
  end
end
