class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :check_owner, only: [:edit, :update, :destroy]


  def index
    @events = Event.order(created_at: :desc)
  end

  def show
  end

  def new
    # default_tag = Tag.find_by(name: 'その他') || Tag.first
    @event = current_user.events.build(
      title: "",
      description: "",
      start_time: Time.current,
      location: ""
    )
    
    if @event.save(validate: false)
      redirect_to event_event_step_path(@event, :basic_info)
    else
      # エラーハンドリング
      flash[:alert] = "イベントの作成に失敗しました。"
      redirect_to events_path
    end
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
    unless @event.user == current_user
      redirect_to events_path, alert: 'このアクションの権限がありません。'
    end
  end

  def event_params
    params.require(:event).permit(:title, :description, :start_time, :location, :image)
  end
end