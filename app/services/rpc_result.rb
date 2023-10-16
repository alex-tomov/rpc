# frozen_string_literal: true

class RpcResult
  attr_reader :player_choice

  def initialize(player_choice)
    @player_choice = player_choice
  end

  def call
    Rails.logger.info("### Player choice `#{player_choice}`")
    Rails.logger.info("### Computer choice `#{computer_choice}`")

    result
  end

  def computer_used
    api_choice ? :api : :fallback
  end

  private

  def result
    return :player if player_wins?
    return :computer if computer_wins?

    :tie
  end

  def player_wins?
    Competition::RULES[player_choice].include?(computer_choice)
  end

  def computer_wins?
    Competition::RULES[computer_choice].include?(player_choice)
  end

  # Requests `https://5eddt4q9dk.execute-api.us-east-1.amazonaws.com/rps-stage/throw`
  # from https://curbrockpaperscissors.docs.apiary.io/#reference/0/throws/retrieve-throw
  # which always returns 500
  # If provided API does not return result, it generates it locally
  def computer_choice
    @computer_choice ||= api_choice || fallback_choice
  end

  def api_choice
    @api_choice ||= ApiChoice.new.call
  end

  def fallback_choice
    @fallback_choice ||= FallbackChoice.new(player_choice).call
  end
end
