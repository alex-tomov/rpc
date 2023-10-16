# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompetitionsController do
  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #play' do
    let(:player_choice) { Competition::RULES.keys.sample.to_s }
    let(:result) { %i[player computer tie].sample }
    let(:computer_used) { %i[api fallback].sample }
    let(:competition) { Competition.new(player_choice: player_choice) }

    before do
      allow(controller).to receive(:competition).and_return(competition)
      allow(competition).to receive(:play).and_return(result)
      allow(competition).to receive(:computer_used).and_return(computer_used)

      get :play, params: { id: player_choice }
    end

    it 'assigns @player_choice' do
      expect(assigns(:player_choice)).to eq(player_choice)
    end

    it 'assigns @result' do
      expect(result).to eq(assigns(:result))
    end

    it 'returns a successful response' do
      expect(response).to be_successful
    end

    it 'renders correct template' do
      expect(response).to render_template(:play)
    end

    context 'when Competition model is invalid' do
      let(:player_choice) { '' }

      before { allow(competition).to receive(:valid?).and_return(false) }

      it 'assigns @result' do
        expect(assigns(:result)).to eq :invalid
      end
    end
  end
end
