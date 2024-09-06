class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, except: [:toggle_owner_like]
  before_action :set_comment, only: [:destroy, :toggle_owner_like]
  before_action :authorize_user, only: [:destroy]
  before_action :authorize_event_owner, only: [:toggle_owner_like]

  def create
    @comment = @event.comments.build(comment_params)
    @comment.save
    respond_to do |format|
      format.js
      format.html { redirect_to @event }
    end
  end

  def destroy
    @comment.destroy
    redirect_to @event
  end

  def toggle_owner_like
    @comment.toggle_owner_like!
    @event = @comment.event
    @comment.reload # 確実に最新の状態を取得

    Rails.logger.debug "Comment: #{@comment.inspect}"
    Rails.logger.debug "Event: #{@event.inspect}"

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @comment.event }
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def authorize_user
    return if @comment.user == current_user

    redirect_to @event, alert: '権限がありません。'
  end

  def comment_params
    params.require(:comment).permit(:content).merge(user_id: current_user.id, event_id: params[:event_id])
  end

  def authorize_event_owner
    return if current_user == @comment.event.user

    redirect_to @comment.event, alert: 'イベント投稿者のみがこの操作を行えます。'
  end
end
