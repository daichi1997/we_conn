class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event


  def create
    comment = Comment.create(comment_params)
    redirect_to "/event/#{comment.event.id}"

  end
  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def comment_params
    params.require(:comment).permit(:content).merge(user_id: current_user.id, event_id: params[:event_id])
  end
end