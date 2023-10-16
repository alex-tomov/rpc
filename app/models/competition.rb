# frozen_string_literal: true

class Competition
  RULES = {
    rock: %i[scissors hammer],
    paper: %i[rock],
    scissors: %i[paper],
    hammer: %i[scissors paper]
  }.freeze

  include ActiveModel::Validations

  attr_reader :player_choice

  validates :player_choice, inclusion: { in: RULES.keys }

  def initialize(player_choice:)
    @player_choice = player_choice&.to_sym
  end

  def play
    rpc_result.call
  end

  def computer_used
    rpc_result.computer_used
  end

  private

  def rpc_result
    @rpc_result ||= RpcResult.new(player_choice)
  end
end
