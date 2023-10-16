# frozen_string_literal: true

module CompetitionHelper
  def show_result(result)
    return 'It\'s a tie!' if result == :tie

    "#{result.capitalize} wins!"
  end

  def invalid?(result)
    result == :invalid
  end
end
