require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'validations' do
    context 'when in basic_info step' do
      before do
        @event = Event.new
        @event.current_step = 'basic_info'
      end

      it 'requires title' do
        @event.valid?
        expect(@event.errors[:title]).to include('を入力してください')
      end

      it 'requires description' do
        @event.valid?
        expect(@event.errors[:description]).to include('を入力してください')
      end

      it 'requires tag' do
        @event.valid?
        expect(@event.errors[:tag_id]).to include('を入力してください')
      end

      it 'is valid with all required fields' do
        @event.title = 'Test Event'
        @event.description = 'Test Description'
        @event.tag_id = 1
        expect(@event).to be_valid
      end
    end

    context 'when in date_and_location step' do
      before do
        @event = Event.new
        @event.current_step = 'date_and_location'
      end

      it 'requires location' do
        @event.valid?
        expect(@event.errors[:location]).to include('を入力してください')
      end

      it 'requires start_time' do
        @event.valid?
        expect(@event.errors[:start_time]).to include('を入力してください')
      end

      it 'is valid with location and start_time' do
        @event.location = 'Test Location'
        @event.start_time = Time.current + 1.day
        expect(@event).to be_valid
      end
    end

    context 'when in image_upload step' do
      before do
        @event = Event.new
        @event.current_step = 'image_upload'
      end

      it 'is valid without image' do
        expect(@event).to be_valid
      end
    end
  end
end
