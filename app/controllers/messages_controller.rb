class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat_room


  def create
    @message = @chat_room.messages.build(message_params.merge(user: current_user))
    if @message.save
      ActionCable.server.broadcast(
  "chat_room_#{@chat_room.id}",
  { message: render_to_string(partial: 'messages/message', locals: { message: @message }) }
)
      head :ok
    else
      render json: { error: @message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_chat_room
    @event = Event.find(params[:event_id])
    @chat_room = @event.chat_room || @event.create_chat_room!
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
