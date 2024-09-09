require 'rails_helper'

RSpec.describe EventStepsController, type: :controller do
  describe 'PUT update' do
    context 'when in basic_info step' do
      it 'shows error messages when fields are empty' do
        put :update, params: { id: 'basic_info', event: { title: '', description: '', tag_id: '' } }
        expect(response).to redirect_to(wizard_path('basic_info'))
        expect(session[:event_errors]).to include('Titleを入力してください', 'Descriptionを入力してください', 'Tagを入力してください')
      end

      it 'proceeds to next step when all fields are filled' do
        put :update, params: { id: 'basic_info', event: { title: 'Test Event', description: 'Test Description', tag_id: 1 } }
        expect(response).to redirect_to(wizard_path('date_and_location'))
      end
    end

    context 'when in date_and_location step' do
      it 'shows error message when location is empty' do
        put :update, params: { id: 'date_and_location', event: { location: '' } }
        expect(response).to redirect_to(wizard_path('date_and_location'))
        expect(session[:event_errors]).to include('Locationを入力してください')
      end

      it 'proceeds to next step when location is filled' do
        put :update, params: { id: 'date_and_location', event: { location: 'Test Location' } }
        expect(response).to redirect_to(wizard_path('image_upload'))
      end
    end

    context 'when in image_upload step' do
      it 'proceeds to next step without image' do
        put :update, params: { id: 'image_upload', event: { } }
        expect(response).to redirect_to(wizard_path('confirmation'))
      end
    end
  end
end