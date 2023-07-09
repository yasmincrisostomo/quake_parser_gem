require_relative 'parser'
require_relative 'game'

module QuakeParser
  class << self
    attr_reader :parser

    def run(file_path)
      raise Errno::ENOENT, "File not found or unreadable: #{file_path}" unless File.exist?(file_path)

      @parser = Parser.new(File.read(file_path))
      parser.parse_file
      { games: get_games, ranking: get_ranking }
    end

    def get_games
      parser.games.map(&:convert_data_to_hash)
    end

    def get_ranking
      scores = Hash.new(0)

      parser.games.each do |game|
        next unless game

        game.kills.each do |player, kills|
          scores[player] += kills
        end
      end

      scores.sort_by { |_player, score| -score }.to_h
    end
  end
end