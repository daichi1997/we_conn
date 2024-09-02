class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :check_owner, only: [:edit, :update, :destroy]

  def index
    @events = Event.order(created_at: :desc).page(params[:page]).per(6)
  end

  def show
  end

  def new
    initialize_new_event
    redirect_to new_event_step_path(:basic_info)
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: 'イベントを更新しました。'
    else
      render :edit
    end
  end

  def destroy
    if @event.destroy
      redirect_to events_path, notice: 'イベントが正常に削除されました。'
    else
      redirect_to @event, alert: 'イベントの削除に失敗しました。'
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def check_owner
    redirect_to events_path, alert: 'このアクションの権限がありません。' unless current_user_owns_event?
  end

  def current_user_owns_event?
    @event.user == current_user
  end

  def event_params
    params.require(:event).permit(:title, :description, :start_time, :location, :image)
  end

  def initialize_new_event
    @event = current_user.events.new
    session[:event_attributes] = @event.attributes
  end
end
