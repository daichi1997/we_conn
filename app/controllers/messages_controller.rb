class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat_room

  def create
    @message = @chat_room.messages.build(message_params)
    @message.user = current_user
  
    if @message.save
      ActionCable.server.broadcast("chat_room_#{@chat_room.id}", { message: render_to_string(partial: 'messages/message', locals: { message: @message }) })
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to event_chat_room_path(@chat_room.event, @chat_room) }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace('new_message', partial: 'messages/form', locals: { chat_room: @chat_room, message: @message }) }
        format.html { render 'chat_rooms/show', status: :unprocessable_entity }
      end
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