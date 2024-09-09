class EventStepsController < ApplicationController
  include Wicked::Wizard
  before_action :authenticate_user!
  before_action :set_event
  before_action :check_session_data, only: [:show]


  steps :basic_info, :date_and_location, :image_upload, :confirmation

  def show
    @event.current_step = step.to_s
    jump_to(:basic_info) if step == :confirmation && params[:editing]
    render_wizard
  end

  def update
    @event.attributes = event_params if params[:event].present?
    @event.current_step = step.to_s
  
    case step
    when :image_upload
      if params[:remove_image]
        if @event.image.attached?
          @event.image.purge
          session[:event_attributes]&.delete('image')
          redirect_to next_wizard_path and return
        end
      else
        handle_image_upload
      end
    when :basic_info
      handle_basic_info
    when :date_and_location
      handle_date_and_location
    when :image_upload
      handle_image_upload
    when :confirmation
      handle_confirmation
    else
      handle_default
    end
  rescue ActiveRecord::NotNullViolation
    flash[:alert] = "必要な情報が不足しています。最初からやり直してください。"
    redirect_to new_event_path
  end
  
  private

  def event_params
    params.require(:event).permit(:title, :description, :start_time, :end_time, :location, :image, :tag_id)
  end

  def set_event
    @event = if params[:event_id] == 'new'
               current_user.events.new(session[:event_attributes] || {})
             else
               current_user.events.find_or_initialize_by(id: params[:event_id])
             end
    @event.assign_attributes(session[:event_attributes] || {})
    attach_image_from_session
    @event.current_step = step.to_s
    set_default_values
  end

  def attach_image_from_session
    return unless session[:image_blob_id]

    blob = ActiveStorage::Blob.find_signed(session[:image_blob_id])
    @event.image.attach(blob) if blob
  end

  def set_default_values
    @event.start_time ||= Time.current
    @event.location ||= ' '
  end

  def finish_wizard_path
    events_path
  end

  
  def save_event_attributes
    session[:event_attributes] = @event.attributes.except('image')
  end
  
  def attach_new_image
    @event.image.attach(params[:event][:image])
    if @event.image.attached?
      session[:image_blob_id] = @event.image.blob.signed_id
      log_event_status('New image attached')
    else
      log_error('Failed to attach new image')
      @event.errors.add(:image, '画像の添付に失敗しました')
    end
  end

  def remove_image
    @event.image.purge
    session.delete(:image_blob_id)
    log_event_status('Image removed')
  end

  
  def create_new_event
    @event.assign_attributes(event_params)
    if @event.save
      success_redirect('イベントが作成されました。')
    else
      log_error('Failed to create new event')
      render_wizard @event
    end
  end

  def update_existing_event
    if @event.update(event_params)
      success_redirect('イベントが更新されました。')
    else
      log_error('Failed to update existing event')
      render_wizard @event
    end
  end

  def success_redirect(message)
    clear_session
    log_event_status('Event confirmed and saved')
    redirect_to events_path, notice: message
  end

  def handle_default
    if @event.valid?
      save_event_attributes
      redirect_to wizard_path(next_step, event_id: 'new')
    else
      log_error('Event invalid in default handling')
      render_wizard @event
    end
  end
  
  def clear_session
    session.delete(:event_attributes)
    session.delete(:image_blob_id)
    session.delete(:event_id) # イベントIDも明示的に削除
    log_event_status('Session cleared')
  end
  
  def log_event_status(message)
    Rails.logger.info("#{message} - Event ID: #{@event.id}, New Record: #{@event.new_record?}, Step: #{@event.current_step}, Image attached: #{@event.image.attached?}, Attributes: #{@event.attributes}, Session: #{session.to_h}")
  end
  
  def log_error(message)
    Rails.logger.error("#{message} - Event ID: #{@event.id}, Step: #{@event.current_step}, Errors: #{@event.errors.full_messages}")
  end

  def handle_basic_info
    if @event.valid?
      session[:event_attributes] = @event.attributes
      redirect_to next_wizard_path
    else
      session[:event_errors] = @event.errors.full_messages
      redirect_to wizard_path(:basic_info)
    end
  end

  def handle_date_and_location
    if @event.valid?
      session[:event_attributes] = @event.attributes
      redirect_to next_wizard_path
    else
      session[:event_errors] = @event.errors.full_messages
      redirect_to wizard_path(:date_and_location)
    end
  end
  
  def handle_image_upload
    if params[:event] && params[:event][:image]
      blob = ActiveStorage::Blob.create_and_upload!(
        io: params[:event][:image].open,
        filename: params[:event][:image].original_filename,
        content_type: params[:event][:image].content_type
      )
      session[:image_blob_id] = blob.signed_id
    end

    save_event_attributes
    redirect_to wizard_path(next_step, event_id: 'new')
  end
  
  def handle_confirmation
    if session[:event_attributes].present? && @event.valid?
      @event.save
      clear_session_data
      redirect_to events_path, notice: 'イベントが正常に作成されました。'
    else
      if session[:event_attributes].blank?
        flash[:alert] = "必要な情報が不足しています。最初からやり直してください。"
        redirect_to new_event_path
      else
        session[:event_errors] = @event.errors.full_messages
        redirect_to wizard_path(:confirmation)
      end
    end
  end

  def handle_default
    if @event.valid?
      session[:event_attributes] = @event.attributes
      redirect_to next_wizard_path
    else
      session[:event_errors] = @event.errors.full_messages
      redirect_to wizard_path(step)
    end
  end

  def clear_session_data
    session.delete(:event_attributes)
    session.delete(:event_errors)
    session.delete(:event_id)
  end
  
  def check_session_data
    unless session[:event_attributes].present? || params[:id] == 'basic_info'
      flash[:alert] = "セッションの有効期限が切れました。最初からやり直してください。"
      redirect_to new_event_path
    end
  end
  
  
end
