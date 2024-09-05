class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event


  def create
    @comment = @event.comments.build(comment_params)
    @comment.save
    respond_to do |format|
      format.js
      format.html { redirect_to @event }
   end
 end
  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def comment_params
    params.require(:comment).permit(:content).merge(user_id: current_user.id, event_id: params[:event_id])
  end
end