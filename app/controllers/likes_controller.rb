class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event

  def create
    @like = current_user.likes.build(event: @event)
    if @like.save
      render json: { likes_count: @event.likes.count }
    else
      render json: { error: '失敗しました' }, status: :unprocessable_entity
    end
  end

  def destroy
    @like = current_user.likes.find_by(event: @event)
    if @like&.destroy
      render json: { likes_count: @event.likes.count }
    else
      render json: { error: '取り消しに失敗しました' }, status: :unprocessable_entity
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end
end