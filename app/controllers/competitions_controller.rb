# frozen_string_literal: true

class CompetitionsController < ApplicationController
  def index; end

  def play
    @player_choice = player_choice
    @result = competition.valid? ? competition.play : :invalid
    @computer_used = competition.valid? ? competition.computer_used : :invalid
  end

  private

  def competition
    @competition ||= Competition.new(player_choice: player_choice)
  end

  def player_choice
    params[:id]
  end
end
