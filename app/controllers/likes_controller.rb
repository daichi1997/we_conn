class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event

  def create
    return head :forbidden unless request.referer&.include?(event_path(@event))

    like = current_user.likes.build(event: @event)
    like.save
    respond_to do |format|
      format.js
      format.html { redirect_to @event }
    end
  end

  def destroy
    return head :forbidden unless request.referer&.include?(event_path(@event))

    like = current_user.likes.find_by(event: @event)
    like&.destroy
    respond_to do |format|
      format.js
      format.html { redirect_to @event }
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end
end