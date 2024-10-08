class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, except: [:toggle_owner_like]
  before_action :set_comment, only: [:destroy, :toggle_owner_like]
  before_action :authorize_user, only: [:destroy]
  before_action :authorize_event_owner, only: [:toggle_owner_like]

  def create
    @comment = @event.comments.build(comment_params)
    @comment.save
  end

  def destroy
    @comment.destroy
    redirect_to @event
  end

  def toggle_owner_like
    @comment = Comment.find(params[:id])
    @comment.toggle_owner_like!
    @event = @comment.event
  
    Rails.logger.debug "Toggle owner like for comment #{@comment.id}"
    Rails.logger.debug "Turbo Stream request: #{request.format.symbol}"
  
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @event }
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
