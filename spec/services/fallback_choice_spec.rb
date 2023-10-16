# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FallbackChoice do
  describe '#call' do
    subject(:call) { described_class.new(player_choice).call }

    context "when player choice is 'hammer'" do
      let(:player_choice) { :hammer }

      it 'returns a random choice from the complete set of choices' do
        expect(Competition::RULES.keys).to include(call)
      end
    end

    context "when player choice is 'rock'" do
      let(:player_choice) { :rock }

      it 'returns a random choice from the complete set of choices' do
        expect(Competition::RULES.keys).to include(call)
      end
    end

    context "when player choice is 'paper'" do
      let(:player_choice) { :paper }

      it 'returns a random choice from the complete set of choices' do
        expect(Competition::RULES.keys).to include(call)
      end
    end

    context "when player choice is 'scissors'" do
      let(:player_choice) { :scissors }

      it 'returns a random choice from the complete set of choices' do
        expect(Competition::RULES.keys).to include(call)
      end
    end
  end
end
