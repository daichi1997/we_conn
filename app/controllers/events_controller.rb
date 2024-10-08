class EventsController < ApplicationController
  require 'open-uri'
  require 'nokogiri'

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :check_owner, only: [:edit, :update, :destroy]

  def index
    @months = Month.all
    @days = Day.all

    @q = Event.includes(user: { avatar_attachment: :blob }, image_attachment: :blob).ransack(params[:q])
    # userとavatar_attachmentを含めています

    @events = if params[:tag_id].present?
                @q.result(distinct: true).where(tag_id: params[:tag_id])
              else
                @q.result(distinct: true)
              end

    # 月日での絞り込み
    @events = @events.by_month_and_day(params[:month], params[:day]) if params[:month].present? && params[:day].present?

    @events = @events.order(created_at: :desc).page(params[:page]).per(6)
  end

  def show
    @comment = Comment.new
    @comments = @event.comments.includes(:user)
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

  def preview_description
    url = params[:url]
    begin
      doc = Nokogiri::HTML(URI.open(url))
      description = doc.at('meta[property="og:description"]')&.[]('content') ||
                    doc.at('meta[name="description"]')&.[]('content') ||
                    '説明が見つかりませんでした。'

      render json: { description: }
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
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
    params.require(:event).permit(:title, :description, :start_time, :location, :image, :tag_id).merge(user_id: current_user.id)
  end

  def initialize_new_event
    @event = current_user.events.new
    session[:event_attributes] = @event.attributes
  end
end
