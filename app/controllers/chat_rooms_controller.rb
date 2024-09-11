class ChatRoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event
  before_action :authorize_chat_room_access, only: [:show]

  def show
    @chat_room = @event.chat_room || @event.create_chat_room!(user: current_user)
    @messages = @chat_room.messages.includes(:user)
    @message = Message.new
    @participants = @event.participants
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def authorize_chat_room_access
    Rails.logger.debug "Event ID: #{@event.id}"
    Rails.logger.debug "Current user ID: #{current_user.id}"
    Rails.logger.debug "Participants: #{@event.participants.map(&:id)}"

    return if @event.participants.include?(current_user)

    flash[:alert] = 'このチャットルームにアクセスする権限がありません。'
    redirect_to events_path
  end
end
