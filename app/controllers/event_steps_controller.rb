class EventStepsController < ApplicationController
  include Wicked::Wizard
  before_action :authenticate_user!
  before_action :set_event

  steps :basic_info, :date_and_location, :image_upload, :confirmation

  def show
    case step
    when :confirmation
      jump_to(:basic_info) if params[:editing]
    end
    render_wizard
  end

  def update
    case step
    when :image_upload
      if params[:remove_image]
        @event.image.purge
        redirect_to wizard_path(:image_upload) and return
      elsif params[:event] && params[:event][:image]
        @event.image.attach(params[:event][:image])
        redirect_to wizard_path(:image_upload) and return
      end
    when :confirmation
      @event.attributes = event_params if params[:event].present?
      if @event.save
        redirect_to events_path, notice: 'イベントが作成されました。' and return
      else
        render_wizard @event and return
      end
    else
      @event.attributes = event_params if params[:event].present?
    end

      render_wizard @event
end

  private

  def event_params
    params.require(:event).permit(:title, :description, :start_time, :end_time, :location, :image)
  end

  def set_event
    @event = current_user.events.find(params[:event_id])
  end

  def finish_wizard_path
      events_path
  end
end