# frozen_string_literal: true

# spec/models/competition_spec.rb
require 'rails_helper'

RSpec.describe Competition do
  let(:competition) { described_class.new(player_choice: :rock) }
  let(:rpc_result_instance) { instance_double('RpcResult', computer_choice: :scissors) }

  describe '#initialize' do
    context 'with a valid player choice' do
      it 'initializes successfully' do
        expect(competition).to be_valid
      end
    end

    context 'with a nil player choice' do
      it 'initializes with a nil player choice' do
        competition = described_class.new(player_choice: nil)
        expect(competition.player_choice).to be_nil
      end
    end

    context 'with an invalid player choice' do
      it 'initializes with an invalid player choice' do
        expect(described_class.new(player_choice: :invalid_choice)).not_to be_valid
      end
    end
  end

  describe 'validations' do
    context 'when validates player_choice' do
      context 'when valid' do
        it { expect(described_class.new(player_choice: 'rock')).to be_valid }
      end

      context 'when invalid' do
        context 'when player_choice is `nil`' do
          it { expect(described_class.new(player_choice: nil)).to be_invalid }
        end

        context 'when player_choice is empty string' do
          it { expect(described_class.new(player_choice: '')).to be_invalid }
        end

        context 'when player_choice is something not included into the list' do
          it { expect(described_class.new(player_choice: 'something')).to be_invalid }
        end
      end
    end
  end

  describe '#play' do
    before { allow(competition).to receive(:rpc_result).and_return(rpc_result_instance) }

    it 'returns :player when player wins' do
      allow(rpc_result_instance).to receive(:call).and_return(:player)
      expect(competition.play).to eq(:player)
    end

    it 'returns :computer when computer wins' do
      allow(rpc_result_instance).to receive(:call).and_return(:computer)
      expect(competition.play).to eq(:computer)
    end

    it "returns :tie when it's a tie" do
      allow(rpc_result_instance).to receive(:call).and_return(:tie)
      expect(competition.play).to eq(:tie)
    end
  end
end
