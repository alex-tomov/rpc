# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RpcResult do
  subject(:rpc_result) { described_class.new(:rock) }

  describe '#call' do
    it 'returns :player' do
      allow(rpc_result).to receive(:computer_choice).and_return(:scissors)
      allow(rpc_result).to receive(:player_choice).and_return(:rock)
      expect(rpc_result.call).to eq :player
    end

    it 'returns :computer' do
      allow(rpc_result).to receive(:player_choice).and_return(:scissors)
      allow(rpc_result).to receive(:computer_choice).and_return(:rock)
      expect(rpc_result.call).to eq :computer
    end

    it 'returns :tie' do
      allow(rpc_result).to receive(:player_choice).and_return(:rock)
      allow(rpc_result).to receive(:computer_choice).and_return(:rock)
      expect(rpc_result.call).to eq :tie
    end
  end

  describe '#computer_choice' do
    it 'returns a valid choice' do
      allow(rpc_result).to receive(:api_choice).and_return(:scissors)
      expect(rpc_result.send(:computer_choice)).to(satisfy { |choice| Competition::RULES.keys.include?(choice) })
    end
  end
end
