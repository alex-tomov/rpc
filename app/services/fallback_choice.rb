# frozen_string_literal: true

class FallbackChoice
  def initialize(player_choice)
    @player_choice = player_choice
  end

  def call
    Competition::RULES.keys.sample
  end

  private

  attr_reader :player_choice
end
