class ChatRoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_chat_room_access, only: [:show]

  def show
    @chat_room = @event.chat_room || @event.create_chat_room!(user: current_user)
    @messages = @chat_room.messages.includes(:user)
    @message = Message.new
    @participants = @event.comments.where(liked_by_owner: true).map(&:user).uniq
  end

  private

  def authorize_chat_room_access
    if params[:id].blank?
      flash[:alert] = "チャットルームが指定されていません。"
      redirect_to events_path and return
    end
  
    @chat_room = ChatRoom.find_by(id: params[:id])
    
    if @chat_room.nil?
      flash[:alert] = "指定されたチャットルームは存在しません。"
      redirect_to events_path and return
    end
  
    unless @chat_room.users.include?(current_user)
      flash[:alert] = "このチャットルームにアクセスする権限がありません。"
      redirect_to events_path
    end
  end
end
