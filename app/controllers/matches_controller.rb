class MatchesController < ApplicationController
  before_action :authenticate_user!

  def index
    @matched_events = current_user.matched_events
    if @matched_events.empty?
      flash[:notice] = "マッチングがありません"
      redirect_to events_path # イベント一覧ページへリダイレクト
    end

  end
end
