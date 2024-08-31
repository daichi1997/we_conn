class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @events = Event.order(created_at: :desc)
  end

  def show
  end

  def new
    # default_tag = Tag.find_by(name: 'その他') || Tag.first

    @event = current_user.events.build(title: "未設定",description: "説明未設定",start_time: Time.current,location: "未設定",

    )  # 一時的なタイトルを設定
    if @event.save(validate: false)
      redirect_to event_event_step_path(@event, :basic_info)
    else
      redirect_to events_path, alert: 'イベントの作成に失敗しました。'
    end
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to event_step_path(@event, :basic_info)
    else
      render :new
      end

  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to events_url, notice: 'Event was successfully destroyed.'
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :start_time,:location,:image).merge(user_id: current_user.id)
  end
end
