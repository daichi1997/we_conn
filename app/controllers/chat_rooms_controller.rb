class ChatRoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event

  def show
    @chat_room = @event.chat_room || @event.create_chat_room!
    @messages = @chat_room.messages.includes(:user)
    @message = Message.new
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end
end