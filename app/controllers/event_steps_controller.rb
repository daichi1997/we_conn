class EventStepsController < ApplicationController
  include Wicked::Wizard
  before_action :authenticate_user!
  before_action :set_event

  steps :basic_info, :date_and_location, :image_upload, :confirmation

  def show
    render_wizard
  end

  def update
    @event.attributes = event_params if params[:event].present?
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
    if @event.save
      events_path
    else
      wizard_path(:confirmation)
    end
  end
end